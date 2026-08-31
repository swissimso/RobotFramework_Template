*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${NOTE_TAKER_URL}    https://testpages.eviltester.com/apps/note-taker/
${TITLE_FIELD}       css=#note-title-input
${NOTE_FIELD}        main textarea
${ADD_BUTTON}        main button:has-text("Add")
${SHOW_BUTTON}       main button:has-text("Show")
${CLEAR_ALL_BUTTON}  main button:has-text("Clear All")

*** Keywords ***
Open Note Taker Page
    Open Browser To Page    ${NOTE_TAKER_URL}

Note Taker Page Should Be Open
    Page Should Have Heading    Note Taker
    Element Should Be Visible    ${TITLE_FIELD}

Add Note
    [Arguments]    ${title}    ${note}
    Input Text To Field    ${TITLE_FIELD}    ${title}
    Input Text To Field    ${NOTE_FIELD}    ${note}
    Click Element    ${ADD_BUTTON}

Show Notes
    Click Element    ${SHOW_BUTTON}

Clear All Notes
    Click Element    ${CLEAR_ALL_BUTTON}