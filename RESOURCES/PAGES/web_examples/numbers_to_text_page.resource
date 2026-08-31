*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${NUMBERS_TO_TEXT_URL}    https://testpages.eviltester.com/apps/numbers-to-text/
${NUMBER_ENTRY}           css=#numentry
${SHOW_AS_PARA}           css=#show-as-para
${RESULT_AREA}            main

*** Keywords ***
Open Numbers To Text Page
    Open Browser To Page    ${NUMBERS_TO_TEXT_URL}

Numbers To Text Page Should Be Open
    Page Should Have Heading    Numbers to Text
    Element Should Be Visible    ${NUMBER_ENTRY}

Show Numbers As Text
    [Arguments]    ${numbers}
    Input Text To Field    ${NUMBER_ENTRY}    ${numbers}
    Click Element    ${SHOW_AS_PARA}

Numbers Text Result Should Be Shown
    [Arguments]    ${expected}
    Element Text Should Contain    ${RESULT_AREA}    ${expected}