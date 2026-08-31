*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/canvas_draw_page.resource
Test Tags         web    apps    canvas
Suite Setup       Open Canvas Draw Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Canvas Draw Page Loads
    [Tags]    REQ-WEB-CANVASDRAW-001
    Canvas Draw Page Should Be Open

Canvas Commands Can Be Shown And Cleared
    [Tags]    REQ-WEB-CANVASDRAW-002
    Show Canvas Drawing
    Clear Canvas Drawing