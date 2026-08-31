*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/simulated_login_page.resource
Test Tags         web    apps    login
Suite Setup       Open Simulated Login Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Simulated Login Page Loads
    [Tags]    REQ-WEB-LOGIN-001
    Simulated Login Page Should Be Open

Admin Can Log In
    [Tags]    REQ-WEB-LOGIN-002
    Log In As Admin
    Admin Login Should Be Shown