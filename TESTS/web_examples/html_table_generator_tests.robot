*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/html_table_generator_page.resource
Test Tags         web    apps    table
Suite Setup       Open HTML Table Generator Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
HTML Table Generator Page Loads
    [Tags]    REQ-WEB-TABLE-001
    HTML Table Generator Page Should Be Open

Generated Table HTML Can Be Copied
    [Tags]    REQ-WEB-TABLE-002
    Copy Generated Table HTML