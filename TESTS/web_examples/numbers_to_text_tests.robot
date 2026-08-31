*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/numbers_to_text_page.resource
Test Tags         web    apps    conversion
Suite Setup       Open Numbers To Text Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Numbers To Text Page Loads
    [Tags]    REQ-WEB-NUMBERS-001
    Numbers To Text Page Should Be Open

Numbers Can Be Shown As Text
    [Tags]    REQ-WEB-NUMBERS-002
    Show Numbers As Text    123
    Numbers Text Result Should Be Shown    one