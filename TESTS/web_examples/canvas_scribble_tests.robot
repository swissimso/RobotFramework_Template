*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/canvas_scribble_page.resource
Test Tags         web    apps    canvas
Suite Setup       Open Canvas Scribble Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Canvas Scribble Page Loads
    [Tags]    REQ-WEB-CANVASSCRIBBLE-001
    Canvas Scribble Page Should Be Open

Canvas Events Can Be Shown
    [Tags]    REQ-WEB-CANVASSCRIBBLE-002
    Show Canvas Events