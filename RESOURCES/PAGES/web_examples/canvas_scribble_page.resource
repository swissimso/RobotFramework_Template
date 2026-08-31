*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${CANVAS_SCRIBBLE_URL}    https://testpages.eviltester.com/apps/canvas-scribble/
${CANVAS}                 main canvas
${SHOW_EVENTS_BUTTON}     main button:has-text("Show Events")

*** Keywords ***
Open Canvas Scribble Page
    Open Browser To Page    ${CANVAS_SCRIBBLE_URL}

Canvas Scribble Page Should Be Open
    Page Should Have Heading    Canvas Scribble
    Element Should Be Visible    ${CANVAS}

Show Canvas Events
    Click Element    ${SHOW_EVENTS_BUTTON}