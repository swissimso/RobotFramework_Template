*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${TABLE_GENERATOR_URL}    https://testpages.eviltester.com/apps/html-table-generator/
${GENERATED_TABLE}        main table
${COPY_BUTTON}            main button:has-text("Copy Table HTML")

*** Keywords ***
Open HTML Table Generator Page
    Open Browser To Page    ${TABLE_GENERATOR_URL}

HTML Table Generator Page Should Be Open
    Page Should Have Heading    HTML Table Generator
    Element Should Be Visible    ${GENERATED_TABLE}

Copy Generated Table HTML
    Click Element    ${COPY_BUTTON}