*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/client_server_form_page.resource
Test Tags         web    apps    form
Suite Setup       Open Client Server Form Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Client Server Form Page Loads
    [Tags]    REQ-WEB-CLIENTFORM-001
    Client Server Form Page Should Be Open

Valid Client Server Form Can Be Submitted
    [Tags]    REQ-WEB-CLIENTFORM-002
    Submit Valid Client Server Form