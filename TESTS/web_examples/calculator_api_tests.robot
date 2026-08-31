*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/calculator_api_page.resource
Test Tags         web    apps    api
Suite Setup       Open Calculator API Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Calculator API Documentation Page Loads
    [Tags]    REQ-WEB-API-001
    Calculator API Page Should Be Open

Calculator API Form UI Is Reachable
    [Tags]    REQ-WEB-API-002
    Open Calculator API Form UI
    Calculator API Form UI Should Be Open