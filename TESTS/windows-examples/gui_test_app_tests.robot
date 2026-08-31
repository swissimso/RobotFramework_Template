*** Settings ***
Documentation       UI tests for the deterministic Windows Forms GUI Test Playground.
Resource            ../../RESOURCES/PAGES/windows-examples/gui_test_app_page.resource
Test Tags           windows    gui-test-app
Suite Setup         Open GUI Test App
Suite Teardown      Close GUI Test App
Test Setup          Reset GUI Test App
Test Teardown       Run Keyword If Test Failed    Capture Windows Failure Screenshot

*** Test Cases ***
GUI Test App Opens Ready
    [Tags]    REQ-WIN-GUIAPP-001
    GUI Test App Should Be Ready

Typing Updates Character Count
    [Tags]    REQ-WIN-GUIAPP-002
    Enter Input Text    hello
    Input Character Count Should Be    5
    Status Should Be    Input changed

Echo Processing Returns Input
    [Tags]    REQ-WIN-GUIAPP-003
    Enter Input Text    hello
    Process Input
    Output Should Be    hello
    Status Should Be    Processed successfully

Reverse Processing Reverses Input
    [Tags]    REQ-WIN-GUIAPP-004
    Enter Input Text    hello
    Select Reverse Mode
    Process Input
    Output Should Be    olleh

Repeat Processing Duplicates Input
    [Tags]    REQ-WIN-GUIAPP-005
    Enter Input Text    hello
    Select Repeat Mode
    Process Input
    Output Should Be    hello | hello

Modifiers Transform Output
    [Tags]    REQ-WIN-GUIAPP-006
    Enter Input Text    hello
    Enable Uppercase Option
    Enable Brackets Option
    Process Input
    Output Should Be    [HELLO]
    Options Should Be    Options: UPPERCASE + brackets

Empty Input Shows Validation Error
    [Tags]    REQ-WIN-GUIAPP-007
    Process Input
    Output Should Be    ERROR: Input is empty
    Status Should Be    Validation failed

Clear Removes Input And Output
    [Tags]    REQ-WIN-GUIAPP-008
    Enter Input Text    hello
    Process Input
    Clear Input And Output
    Output Should Be    ${EMPTY}
    Input Character Count Should Be    0

Counter Increments
    [Tags]    REQ-WIN-GUIAPP-009
    Increment Counter
    Increment Counter
    Increment Counter
    Counter Should Be    3

State Toggle Changes State
    [Tags]    REQ-WIN-GUIAPP-010
    Toggle State
    State Should Be    ON
    Toggle State
    State Should Be    OFF

# Intentional Windows Failure Captures Screenshot
#    [Tags]    REQ-WIN-GUIAPP-FAILURE    simulation
#    Enter Input Text    screenshot evidence
#    Process Input
#    Output Should Be    deliberately incorrect expected output
