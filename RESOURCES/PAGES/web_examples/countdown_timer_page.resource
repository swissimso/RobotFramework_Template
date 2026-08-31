*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${COUNTDOWN_URL}    https://testpages.eviltester.com/apps/countdown-timer/
${SECONDS_FIELD}    main input[type="number"]
${START_BUTTON}     main button:has-text("Start Timer")
${STOP_BUTTON}      main button:has-text("Stop Timer")
${CLEAR_BUTTON}     main button:has-text("Clear Timer")

*** Keywords ***
Open Countdown Timer Page
    Open Browser To Page    ${COUNTDOWN_URL}

Countdown Timer Page Should Be Open
    Page Should Have Heading    Countdown Timer
    Element Should Be Visible    ${SECONDS_FIELD}

Set Countdown Seconds
    [Arguments]    ${seconds}
    Input Text To Field    ${SECONDS_FIELD}    ${seconds}

Start Countdown
    Click Element    ${START_BUTTON}

Stop Countdown
    Click Element    ${STOP_BUTTON}

Clear Countdown
    Click Element    ${CLEAR_BUTTON}