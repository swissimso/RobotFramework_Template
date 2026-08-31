*** Settings ***
Documentation    Page Object for the deterministic Windows Forms GUI Test Playground.
Resource         ../../UTILS/windows_utils.resource

*** Variables ***
${GUI_TEST_APP}       ${CURDIR}${/}..${/}..${/}..${/}GuiTestApp${/}GuiTestApp.exe
${MAIN_WINDOW}        //Window[@AutomationId='MainWindow']
${INPUT_TEXT}         //*[@AutomationId='InputText']
${OUTPUT_TEXT}        //*[@AutomationId='OutputText']
${MODE_REVERSE}       //*[@AutomationId='ModeReverse']
${MODE_REPEAT}        //*[@AutomationId='ModeRepeat']
${UPPERCASE}          //*[@AutomationId='UppercaseCheckBox']
${BRACKETS}           //*[@AutomationId='BracketsCheckBox']
${PROCESS}            //*[@AutomationId='ProcessButton']
${CLEAR_TEXT}         //*[@AutomationId='ClearButton']
${COUNTER}            //*[@AutomationId='CounterButton']
${STATE}              //*[@AutomationId='StateButton']
${RESET}              //*[@AutomationId='ResetButton']
${STATUS}             //*[@AutomationId='StatusLabel']
${INPUT_COUNT}        //*[@AutomationId='InputCountLabel']
${OPTIONS}            //*[@AutomationId='OptionsLabel']
${COUNTER_VALUE}      //*[@AutomationId='CounterValueLabel']
${STATE_INDICATOR}    //*[@AutomationId='StateIndicatorLabel']

*** Keywords ***
Open GUI Test App
    Launch Windows Application    ${GUI_TEST_APP}
    Windows Element Should Be Visible    ${MAIN_WINDOW}

Close GUI Test App
    Close Windows Application

Reset GUI Test App
    Click Windows Element    ${RESET}

Enter Input Text
    [Arguments]    ${text}
    Type Windows Text    ${INPUT_TEXT}    ${text}

Process Input
    Click Windows Element    ${PROCESS}

Select Reverse Mode
    Click Windows Element    ${MODE_REVERSE}

Select Repeat Mode
    Click Windows Element    ${MODE_REPEAT}

Enable Uppercase Option
    Click Windows Element    ${UPPERCASE}

Enable Brackets Option
    Click Windows Element    ${BRACKETS}

Clear Input And Output
    Click Windows Element    ${CLEAR_TEXT}

Increment Counter
    Click Windows Element    ${COUNTER}

Toggle State
    Click Windows Element    ${STATE}

GUI Test App Should Be Ready
    Windows Element Name Should Be    ${STATUS}    Ready

Input Character Count Should Be
    [Arguments]    ${count}
    Windows Element Name Should Be    ${INPUT_COUNT}    Characters: ${count}

Output Should Be
    [Arguments]    ${expected}
    Windows Text Should Be    ${OUTPUT_TEXT}    ${expected}

Status Should Be
    [Arguments]    ${expected}
    Windows Element Name Should Be    ${STATUS}    ${expected}

Options Should Be
    [Arguments]    ${expected}
    Windows Element Name Should Be    ${OPTIONS}    ${expected}

Counter Should Be
    [Arguments]    ${expected}
    Windows Element Name Should Be    ${COUNTER_VALUE}    Counter: ${expected}

State Should Be
    [Arguments]    ${expected}
    Windows Element Name Should Be    ${STATE_INDICATOR}    State indicator: ${expected}
