*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/button_calculator_page.resource
Test Tags         web    apps    calculator
Suite Setup       Open Button Calculator Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Button Calculator Page Loads
    [Tags]    REQ-WEB-BUTTONCALC-001
    Button Calculator Page Should Be Open

Calculation Can Be Entered And Cleared
    [Tags]    REQ-WEB-BUTTONCALC-002
    Calculate One Plus One
    Clear Button Calculator