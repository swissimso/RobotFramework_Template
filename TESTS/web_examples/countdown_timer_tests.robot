*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/countdown_timer_page.resource
Test Tags         web    apps    timer
Suite Setup       Open Countdown Timer Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Countdown Timer Page Loads
    [Tags]    REQ-WEB-TIMER-001
    Countdown Timer Page Should Be Open

Countdown Can Be Started And Stopped
    [Tags]    REQ-WEB-TIMER-002
    Set Countdown Seconds    5
    Start Countdown
    Stop Countdown
    Clear Countdown