# Robot Framework POM Template

A starter template for automated UI testing with Robot Framework and the **Page Object Model
(POM)** pattern. It contains web examples powered by Browser/Playwright and a Windows desktop
example powered by FlaUI.

## Structure

```
RESOURCES/
  UTILS/                    Generic, page-agnostic keywords (click, type, read text, ...).
    web_utils.resource        Wraps the Browser (Playwright) library.
    windows_utils.resource     Wraps the FlaUILibrary (Windows UIA) library.
  PAGES/                    One file per page/screen: locators + page-specific keywords only.
    web_examples/           Page objects for the web examples.
    windows-examples/       Page object for the GUI Test Playground.
TESTS/                      Test layer - suites only, no locators, no raw library calls.
  web_examples/             Robot Framework suites for the web examples.
  windows-examples/
    gui_test_app_tests.robot
GuiTestApp/                 Deterministic Windows Forms application used by the FlaUI suite.
custom_report.py            Adds Requirement IDs and Windows failure screenshots to reports.
requirements.txt            Core Robot Framework only
requirements-web.txt        Web stack (Playwright via Browser library)
requirements-windows.txt    Windows desktop stack (FlaUI)
requirements-dev.txt        Optional linting tools
```

**Layering rule:** `TESTS` → `PAGES` → `UTILS` → external library. Suites import page objects;
page objects import utility resources. This keeps selectors and automation-engine details out of
the test cases.

## Test suite strategy

- **One suite file per page or application feature** (`html_form_tests.robot`,
  `gui_test_app_tests.robot`). Each suite groups the test cases that exercise that one
  page/screen, keeping `Suite Setup`/`Suite Teardown` (open/close browser or app) local and
  cheap to reason about.
- **One test case = one user scenario**, written only with page-object keywords, e.g.
  `Fill Username`, `Submit Form`, `Press Equals`. This keeps test cases readable as
  documentation and immune to locator changes.
- **Group suites by domain** under `TESTS/<domain>/` (`web_examples`, `windows-examples`, and
  later e.g. `api`, `mobile`). Each domain folder can get its own `Suite Setup`/`Teardown` strategy since a
  browser and a desktop app are opened/closed very differently.
- **Tag every suite** (`Test Tags` at suite level, e.g. `web`, `windows`, `smoke`,
  `regression`) so CI can select subsets with `robot --include smoke`.
- Grow by adding new files, not new folders-of-one: a new page gets a new file in
  `RESOURCES/PAGES/<domain>/`, a new suite gets a new file in `TESTS/<domain>/`.

## Installation

### Prerequisites

- Python 3.10 or later, available as `python` from PowerShell.
- An internet connection for package installation and the web examples.
- Windows for the FlaUI desktop examples. The web examples run on any platform supported by
  Python and Playwright.

### Create the environment

Run these commands from the repository root:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Install the automation stack you need:

```powershell
# Web GUI tests (Browser library and Playwright)
python -m pip install -r requirements-web.txt
rfbrowser init

# Windows desktop GUI tests (Windows only)
python -m pip install -r requirements-windows.txt
```

`rfbrowser init` is required once per environment. It downloads the Playwright browser
binaries used by the web tests. The Windows/FlaUI dependency installs Python.NET automatically.

### VS Code setup

Install the RobotCode extension, then open the repository root folder (the folder containing
`TESTS`, `RESOURCES`, and `.venv`) in VS Code. Select the project interpreter with
**Python: Select Interpreter** and choose `.venv\Scripts\python.exe`. Reload the VS Code window
after changing the interpreter so RobotCode refreshes test discovery. You can then right-click a
suite or test in a `.robot` file and select **Run Test**.

### Package installation troubleshooting

If pip reports `getaddrinfo` or `No matching distribution`, it usually cannot reach its package
index. Check the active configuration:

```powershell
python -m pip config list
```

For a one-time installation from public PyPI, use:

```powershell
python -m pip install -r requirements-web.txt --index-url https://pypi.org/simple
python -m pip install -r requirements-windows.txt --index-url https://pypi.org/simple
```

For an offline environment, ask the package-mirror administrator to provide `robotframework`,
`robotframework-browser`, `robotframework-flaui`, and `robotframework-robocop`.

## Usage

Activate the virtual environment before running commands in a new PowerShell session:

```powershell
.venv\Scripts\Activate.ps1
```

### Run test suites

Use the project interpreter so every command runs with the installed test dependencies:

```powershell
# Entire test collection
.venv\Scripts\python.exe -m robot -d output TESTS

# Web test suites only
.venv\Scripts\python.exe -m robot -d output TESTS/web_examples

# Windows desktop suites only (Windows required)
.venv\Scripts\python.exe -m robot -d output TESTS/windows-examples

# One suite
.venv\Scripts\python.exe -m robot -d output TESTS/web_examples/countdown_timer_tests.robot

# Tests carrying a particular tag
.venv\Scripts\python.exe -m robot -d output --include smoke TESTS
```

Robot Framework writes `output.xml`, `log.html`, and `report.html` to the folder passed with
`-d`. Open `output/report.html` for the standard summary report and `output/log.html` for
keyword-level execution details.

The web suites start Chromium headlessly by default. Set `${HEADLESS}` to `${False}` in
`RESOURCES/config.resource` when you need to watch browser interactions locally.

### Generate the enhanced report

Run the custom report script after a terminal test run to add the Requirement ID column. When a
Windows test fails, it also embeds the screenshot captured by the FlaUI test teardown:

```powershell
.venv\Scripts\python.exe -m robot -d output TESTS
.venv\Scripts\python.exe custom_report.py
```

The VS Code right-click **Run Test** command produces standard Robot Framework reports, but does
not invoke `custom_report.py`. Use the terminal workflow above when the enhanced report is needed.

## Requirement IDs in the native report

Each test can carry a requirement tag. `custom_report.py` adds the first matching `REQ-*` tag to
an additional **Requirement ID** column in `output/report.html`.

```powershell
.venv\Scripts\python.exe custom_report.py
```

Add a requirement ID to an individual test case with a tag:

```robotframework
*** Test Cases ***
Example scenario
  [Tags]    REQ-123
  Page Should Be Open
```

The column shows the first `REQ-*` tag on each test; untagged tests display `-`.

## Failure screenshots

Both automation libraries capture a screenshot when a keyword fails, but they store the evidence
in different locations:

- **Web (Browser/Playwright)**: `web_utils.resource` imports `Browser highlight_on_failure=True`.
  On failure it saves a real PNG to `${OUTPUTDIR}/browser/screenshot/fail-screenshot-{index}.png`
  and inserts a clickable thumbnail directly under the failed keyword in `log.html` (not a
  base64 embed - it's a link to the file on disk). `highlight_on_failure=True` also draws a
  border around the selector that could not be found, so the screenshot shows exactly what was
  being looked for.
- **Windows (FlaUI)**: a failed Windows test captures a `.jpg` in
  `${OUTPUTDIR}/windows-screenshots/`. Run `custom_report.py` after the test run to add the image
  to the failed test's native `log.html` and regenerate the reports.

## Windows GUI example

`GuiTestApp/GuiTestApp.exe` is a deterministic Windows Forms application included with the
template. Its page object uses stable UI Automation IDs, and
`TESTS/windows-examples/gui_test_app_tests.robot` exercises typing, text processing modes, modifiers,
validation, reset behavior, a counter, and a state toggle. The suite teardown closes the exact
application process launched by the suite.

Run it manually with `GuiTestApp/run.bat`. Rebuild it after changing its source:

```powershell
GuiTestApp\build.bat
```
