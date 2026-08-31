from __future__ import annotations

import argparse
import sys
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET


MARKER = "<!-- requirement-id-column -->"
HEADER = '''        <th class="details-col-requirement" title="Requirement ID">
          <div class='details-col-header'>Requirement ID</div>
        </th>
'''
ROW = '''    <td class="details-col-requirement"><div>{{html requirementId(tags)}}</div></td>
'''
SCRIPT = '''
<!-- requirement-id-column -->
<script type="text/javascript">
function requirementId(tags) {
    for (var index = 0; index < tags.length; index++) {
        var match = /^(?:requirement\\s*:\\s*)?(REQ-[A-Za-z0-9._-]+)$/i.exec(tags[index]);
        if (match)
            return match[1].toUpperCase();
    }
    return '-';
}
</script>
'''


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Add a Requirement ID column to Robot Framework's native HTML report."
    )
    parser.add_argument(
        "--report",
        type=Path,
        default=Path("output/report.html"),
        help="Path to Robot Framework's generated report.html.",
    )
    parser.add_argument(
        "--xml",
        type=Path,
        default=Path("output/output.xml"),
        help="Path to Robot Framework's generated output.xml.",
    )
    parser.add_argument(
        "--log",
        type=Path,
        default=Path("output/log.html"),
        help="Path to Robot Framework's generated log.html.",
    )
    return parser.parse_args()


def replace_once(report: str, old: str, new: str, description: str) -> str:
    if old not in report:
        raise ValueError(f"Could not find native Robot report {description}.")
    return report.replace(old, new, 1)


def enhance_report(report: str) -> str:
    if MARKER in report:
        return report

    report = replace_once(
        report,
        '''        <th class="details-col-status" title="Status">''',
        HEADER + '''        <th class="details-col-status" title="Status">''',
        "Requirement ID header insertion point",
    )
    report = replace_once(
        report,
        '''    <td class="details-col-status"><div><span class="label ${status.toLowerCase()}">${status}</span></div></td>''',
        ROW + '''    <td class="details-col-status"><div><span class="label ${status.toLowerCase()}">${status}</span></div></td>''',
        "Requirement ID row insertion point",
    )
    report = replace_once(
        report,
        "headers: {3: {sorter: 'status'},",
        "headers: {4: {sorter: 'status'},",
        "status-column sorter configuration",
    )
    report = replace_once(
        report,
        "sortList'] = [[3, 0]];",
        "sortList'] = [[4, 0]];",
        "status-column default sort configuration",
    )
    report = report.replace("</body>", SCRIPT + "</body>", 1)
    return report


def safe_name(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", value.lower()).strip("_")


def add_windows_screenshots(xml_path: Path) -> int:
    screenshot_dir = xml_path.parent / "windows-screenshots"
    screenshots = list(screenshot_dir.glob("*.jpg")) if screenshot_dir.exists() else []
    if not screenshots:
        return 0

    root = ET.parse(xml_path).getroot()
    added = 0
    for test in root.iter("test"):
        status = test.find("status")
        tags = {(tag.text or "").lower() for tag in test.findall("./tag")}
        if status is None or status.get("status") != "FAIL" or "windows" not in tags:
            continue
        if any("windows-screenshots/" in (msg.text or "") for msg in test.iter("msg")):
            continue

        test_name = safe_name(test.get("name", ""))
        matching = [image for image in screenshots if test_name in safe_name(image.name)]
        image = max(matching or screenshots, key=lambda candidate: candidate.stat().st_mtime)
        relative_path = image.relative_to(xml_path.parent).as_posix()
        keyword = ET.Element("kw", {"name": "Windows Failure Screenshot", "owner": "custom_report", "type": "TEARDOWN"})
        message = ET.SubElement(keyword, "msg", {"level": "INFO", "html": "true"})
        message.text = f'<a href="{relative_path}" target="_blank"><img src="{relative_path}" style="max-width:800px;"></a>'
        ET.SubElement(keyword, "status", {"status": "PASS"})
        test.insert(list(test).index(status), keyword)
        added += 1

    if added:
        ET.indent(root, space="  ")
        ET.ElementTree(root).write(xml_path, encoding="utf-8", xml_declaration=True)
    return added


def regenerate_native_reports(xml_path: Path, log_path: Path, report_path: Path) -> None:
    command = [
        sys.executable,
        "-m",
        "robot.rebot",
        "--output",
        "NONE",
        "--log",
        str(log_path),
        "--report",
        str(report_path),
        str(xml_path),
    ]
    result = subprocess.run(command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if result.returncode > 250:
        raise RuntimeError(f"Could not regenerate Robot Framework reports:\n{result.stdout}")


def main() -> int:
    args = parse_args()
    report_path = args.report.resolve()
    xml_path = args.xml.resolve()
    log_path = args.log.resolve()
    if not xml_path.exists():
        print(f"Robot Framework output not found: {xml_path}", file=sys.stderr)
        return 1

    try:
        screenshot_count = add_windows_screenshots(xml_path)
        regenerate_native_reports(xml_path, log_path, report_path)
        report = report_path.read_text(encoding="utf-8")
        enhanced = enhance_report(report)
    except (OSError, ValueError, RuntimeError, ET.ParseError) as error:
        print(error, file=sys.stderr)
        return 1

    report_path.write_text(enhanced, encoding="utf-8")
    print(f"Added {screenshot_count} Windows failure screenshot(s).")
    print(f"Requirement ID column added to: {report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
