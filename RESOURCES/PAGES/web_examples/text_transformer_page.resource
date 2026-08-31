*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${TEXT_TRANSFORMER_URL}    https://testpages.eviltester.com/apps/text-transformer/
${TEXT_INPUT}              css=#inputText
${REVERSE_OUTPUT}          main

*** Keywords ***
Open Text Transformer Page
    Open Browser To Page    ${TEXT_TRANSFORMER_URL}

Text Transformer Page Should Be Open
    Page Should Have Heading    Text Transformer
    Element Should Be Visible    ${TEXT_INPUT}

Transform Text
    [Arguments]    ${text}
    Input Text To Field    ${TEXT_INPUT}    ${text}

Reverse Transformation Should Be Shown
    [Arguments]    ${expected}
    Element Text Should Contain    ${REVERSE_OUTPUT}    ${expected}