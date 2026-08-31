*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/server_side_calculator_page.resource
Test Tags         web    apps    calculator
Suite Setup       Open Server Side Calculator Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Server Side Calculator Page Loads
    [Tags]    REQ-WEB-SERVERCALC-001
    Server Side Calculator Page Should Be Open

Server Side Calculation Can Be Submitted
    [Tags]    REQ-WEB-SERVERCALC-002
    Calculate Sum    7    5