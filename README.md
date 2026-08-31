# Robot Framework POM Template

A starter template for building automated software test frameworks with Robot Framework,
using the **Page Object Model (POM)** pattern. It includes a working example for **web GUI
testing** (Browser/Playwright library) and one for **Windows desktop GUI testing** (FlaUI
library).

## Structure

```
RESOURCES/
  UTILS/                    Generic, page-agnostic keywords (click, type, read text, ...).
    web_utils.resource        Wraps the Browser (Playwright) library.
    windows_utils.resource     Wraps the FlaUILibrary (Windows UIA) library.
  PAGES/                    One file per page/screen: locators + page-specific keywords only.
    web/
      html_form_page.resource     POM for testpages.eviltester.com HTML form page.
    windows/
      gui_test_app_page.resource  POM for the deterministic GUI Test Playground.
TESTS/                      Test layer - suites only, no locators, no raw library calls.
  web/
    html_form_tests.robot
  windows/
    gui_test_app_tests.robot
requirements.txt            Core Robot Framework only
requirements-web.txt        Web stack (Playwright via Browser library)
requirements-windows.txt    Windows desktop stack (FlaUI)
requirements-dev.txt        Optional linting tools
```

**Layering rule:** TESTS → PAGES → UTILS → external library. A test file should only ever
import a `PAGES/*.resource` file. A page file should only ever import a `UTILS/*.resource`
file. This keeps locator changes and automation-engine changes isolated to a single layer.

## Test suite strategy

- **One suite file per page or application feature** (`html_form_tests.robot`,
  `gui_test_app_tests.robot`). Each suite groups the test cases that exercise that one
  page/screen, keeping `Suite Setup`/`Suite Teardown` (open/close browser or app) local and
  cheap to reason about.
- **One test case = one user scenario**, written only with page-object keywords, e.g.
  `Fill Username`, `Submit Form`, `Press Equals`. This keeps test cases readable as
  documentation and immune to locator changes.
- **Group suites by domain** under `TESTS/<domain>/` (`web`, `windows`, and later e.g. `api`,
  `mobile`). Each domain folder can get its own `Suite Setup`/`Teardown` strategy since a
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
after changing the interpreter so RobotCode refreshes test discovery.

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
`-d`. Open `output/report.html` after a run for the standard summary report.

### Generate the enhanced report

Run the custom report script after a terminal test run to add the Requirement ID column and
embed the Windows failure screenshots:

```powershell
.venv\Scripts\python.exe -m robot -d output TESTS
.venv\Scripts\python.exe custom_report.py
```

The VS Code right-click **Run Test** command produces Robot Framework's standard reports, but it
does not run `custom_report.py`. Use the terminal workflow above when the enhanced report is
needed.

## Failure Screenshot Simulation

One deliberate failure exists in the web Triangle suite and one in the Windows GUI Test App
suite. Both are tagged `simulation` and verify that Browser and FlaUI screenshots are embedded
in the native `log.html` for failed test steps.

```powershell
# Run only the two screenshot simulations
.venv\Scripts\robot -d output --include simulation TESTS
.venv\Scripts\python custom_report.py

# Run the normal test collection without deliberate failures
.venv\Scripts\robot -d output --exclude simulation TESTS
.venv\Scripts\python custom_report.py
```

## Requirement IDs in the native report

Robot Framework generates its normal `output/report.html`. To add the `Requirement ID`
column without changing its appearance or behavior, run this after the test run:

```powershell
.venv\Scripts\python custom_report.py
```

Add a requirement ID to an individual test case with a tag:

```robotframework
*** Test Cases ***
Example scenario
  [Tags]    REQ-123
  Page Should Be Open
```

The column shows the first `REQ-*` tag on each test; untagged tests display `-`.

## Screenshots on failure

Both automation libraries capture a screenshot automatically when a keyword fails, but they
behave differently - know where to look before you go hunting:

- **Web (Browser/Playwright)**: `web_utils.resource` imports `Browser highlight_on_failure=True`.
  On failure it saves a real PNG to `${OUTPUTDIR}/browser/screenshot/fail-screenshot-{index}.png`
  and inserts a clickable thumbnail directly under the failed keyword in `log.html` (not a
  base64 embed - it's a link to the file on disk). `highlight_on_failure=True` also draws a
  border around the selector that could not be found, so the screenshot shows exactly what was
  being looked for.
- **Windows (FlaUI)**: a failed Windows test captures a `.jpg` in
  `${OUTPUTDIR}/windows-screenshots/`. Run `custom_report.py` after the test run; it finds the
  screenshot, adds it to the failed test's native `log.html` entry, regenerates Robot's native
  `report.html`/`log.html`, and then adds the Requirement ID column to `report.html`.

## Windows GUI example

`GuiTestApp/GuiTestApp.exe` is a deterministic Windows Forms application included with the
template. Its page object uses stable UI Automation IDs, and
`TESTS/windows-examples/gui_test_app_tests.robot` exercises typing, text processing modes, modifiers,
validation, reset behavior, a counter, and a state toggle. The suite teardown closes the exact
application process launched by the suite.

Rebuild it after changing its source:

```powershell
GuiTestApp\build.bat
```
