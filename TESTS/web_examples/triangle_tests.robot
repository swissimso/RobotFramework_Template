*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/triangle_page.resource
Test Tags         web    apps    triangle
Suite Setup       Open Triangle Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Triangle Page Loads
    [Tags]    REQ-WEB-TRIANGLE-001
    Triangle Page Should Be Open

Identify Equilateral Triangle
    [Tags]    REQ-WEB-TRIANGLE-002
    Identify Triangle With Sides    5    5    5
    Triangle Visualisation Should Be Visible

# Intentional Web Failure Captures Screenshot
#    [Tags]    REQ-WEB-TRIANGLE-FAILURE    simulation
#    Missing Triangle Control Should Be Visible