*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${SIMULATED_LOGIN_URL}    https://testpages.eviltester.com/apps/simulated-login/
${USERNAME}               css=#username
${PASSWORD}               css=#password
${LOGIN}                  css=#login

*** Keywords ***
Open Simulated Login Page
    Open Browser To Page    ${SIMULATED_LOGIN_URL}

Simulated Login Page Should Be Open
    Page Should Have Heading    Cookie Controlled Login
    Element Should Be Visible    ${USERNAME}

Log In As Admin
    Input Text To Field    ${USERNAME}    Admin
    Input Text To Field    ${PASSWORD}    AdminPass
    Click Element    ${LOGIN}

Admin Login Should Be Shown
    Element Text Should Contain    main    Admin Logout