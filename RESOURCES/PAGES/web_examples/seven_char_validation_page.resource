*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${SEVEN_CHAR_URL}    https://testpages.eviltester.com/apps/7-char-val/
${VALUE_FIELD}       main input[name="characters"]
${CHECK_INPUT}       main input[value="Check Input"]

*** Keywords ***
Open Seven Character Validation Page
    Open Browser To Page    ${SEVEN_CHAR_URL}

Seven Character Validation Page Should Be Open
    Page Should Have Heading    7 Char Val
    Element Should Be Visible    ${VALUE_FIELD}

Check Seven Character Value
    [Arguments]    ${value}
    Input Text To Field    ${VALUE_FIELD}    ${value}
    Click Element    ${CHECK_INPUT}