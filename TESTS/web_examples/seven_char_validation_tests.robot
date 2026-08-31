*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/seven_char_validation_page.resource
Test Tags         web    apps    validation
Suite Setup       Open Seven Character Validation Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Seven Character Validation Page Loads
    [Tags]    REQ-WEB-VALIDATION-001
    Seven Character Validation Page Should Be Open

Valid Seven Character Value Can Be Checked
    [Tags]    REQ-WEB-VALIDATION-002
    Check Seven Character Value    Abc12*Z