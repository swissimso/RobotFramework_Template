*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${SERVER_CALCULATOR_URL}    https://testpages.eviltester.com/apps/server-side-calculator/
${LEFT_OPERAND}             css=#number1
${RIGHT_OPERAND}            css=#number2
${CALCULATE}                main input[type="submit"], main button:has-text("Calculate")

*** Keywords ***
Open Server Side Calculator Page
    Open Browser To Page    ${SERVER_CALCULATOR_URL}

Server Side Calculator Page Should Be Open
    Page Should Have Heading    Server Side Calculator
    Element Should Be Visible    ${CALCULATE}

Calculate Sum
    [Arguments]    ${left}    ${right}
    Input Text To Field    ${LEFT_OPERAND}    ${left}
    Input Text To Field    ${RIGHT_OPERAND}    ${right}
    Click Element    ${CALCULATE}