*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${CANVAS_DRAW_URL}    https://testpages.eviltester.com/apps/canvas-draw/
${CANVAS}             main canvas
${SHOW_BUTTON}        main input[value="Show"], main button:has-text("Show")
${CLEAR_BUTTON}       main input[value="Clear"], main button:has-text("Clear")

*** Keywords ***
Open Canvas Draw Page
    Open Browser To Page    ${CANVAS_DRAW_URL}

Canvas Draw Page Should Be Open
    Page Should Have Heading    Canvas Draw
    Element Should Be Visible    ${CANVAS}

Show Canvas Drawing
    Click Element    ${SHOW_BUTTON}

Clear Canvas Drawing
    Click Element    ${CLEAR_BUTTON}