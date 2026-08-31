*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${CALCULATOR_API_URL}    https://testpages.eviltester.com/apps/calculator-api/
${CALCULATE_SECTION}     main
${FORM_UI_LINK}          main a:has-text("Server Side Calculator Using API")

*** Keywords ***
Open Calculator API Page
    Open Browser To Page    ${CALCULATOR_API_URL}

Calculator API Page Should Be Open
    Page Should Have Heading    Simple Calculator API
    Element Text Should Contain    ${CALCULATE_SECTION}    /apps/api/calculator/calculate

Open Calculator API Form UI
    Click Element    ${FORM_UI_LINK}

Calculator API Form UI Should Be Open
    Current Url Should Contain    /form-calculator/