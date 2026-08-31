*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${TRIANGLE_URL}    https://testpages.eviltester.com/apps/triangle/
${SIDE_1_FIELD}    css=#side1
${SIDE_2_FIELD}    css=#side2
${SIDE_3_FIELD}    css=#side3
${IDENTIFY}         css=#identify-triangle-action
${TRIANGLE_CANVAS}  css=#triangle-canvas

*** Keywords ***
Open Triangle Page
    Open Browser To Page    ${TRIANGLE_URL}

Triangle Page Should Be Open
    Page Should Have Heading    Triangle
    Element Should Be Visible    ${SIDE_1_FIELD}

Identify Triangle With Sides
    [Arguments]    ${side_1}    ${side_2}    ${side_3}
    Input Text To Field    ${SIDE_1_FIELD}    ${side_1}
    Input Text To Field    ${SIDE_2_FIELD}    ${side_2}
    Input Text To Field    ${SIDE_3_FIELD}    ${side_3}
    Click Element    ${IDENTIFY}

Triangle Visualisation Should Be Visible
    Element Should Be Visible    ${TRIANGLE_CANVAS}

Missing Triangle Control Should Be Visible
    Element Should Be Visible    css=#intentional-missing-triangle-control