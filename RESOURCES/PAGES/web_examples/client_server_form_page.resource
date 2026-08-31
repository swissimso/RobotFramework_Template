*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${FORM_URL}           https://testpages.eviltester.com/apps/client-server-form-validation/
${FIRST_NAME}         css=#firstname
${LAST_NAME}          css=#surname
${AGE}                css=#age
${SUBMIT}             main input[type="submit"], main button:has-text("Submit")

*** Keywords ***
Open Client Server Form Page
    Open Browser To Page    ${FORM_URL}

Client Server Form Page Should Be Open
    Page Should Have Heading    Validated Client Server Form
    Element Should Be Visible    ${FIRST_NAME}

Submit Valid Client Server Form
    Input Text To Field    ${FIRST_NAME}    Ada
    Input Text To Field    ${LAST_NAME}    Lovelace
    Input Text To Field    ${AGE}    36
    Click Element    ${SUBMIT}