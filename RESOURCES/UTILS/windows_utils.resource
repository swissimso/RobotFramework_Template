*** Settings ***
Documentation    Generic Windows UI Automation keywords implemented with FlaUILibrary.
Library          FlaUILibrary    uia=UIA3    screenshot_on_failure=True    screenshot_dir=windows-screenshots

*** Variables ***
${WINDOWS_APP_PID}    ${NONE}

*** Keywords ***
Launch Windows Application
    [Arguments]    ${application}
    ${pid} =    Launch Application    ${application}
    Set Suite Variable    ${WINDOWS_APP_PID}    ${pid}
    RETURN    ${pid}

Close Windows Application
    IF    $WINDOWS_APP_PID is not None
        Run Keyword And Ignore Error    Close Application    ${WINDOWS_APP_PID}
    END

Click Windows Element
    [Arguments]    ${locator}
    Click    ${locator}

Set Windows Text
    [Arguments]    ${locator}    ${text}
    Set Text To Textbox    ${locator}    ${text}

Type Windows Text
    [Arguments]    ${locator}    ${text}
    Press Key    s'CTRL+A'    ${locator}
    Press Key    s'DELETE'    ${locator}
    Press Key    t'${text}'    ${locator}

Windows Text Should Be
    [Arguments]    ${locator}    ${expected}
    ${actual} =    Get Text From Textbox    ${locator}
    Should Be Equal As Strings    ${actual}    ${expected}

Windows Element Name Should Be
    [Arguments]    ${locator}    ${expected}
    Wait Until Keyword Succeeds    10x    100ms    Windows Element Name Should Eventually Be    ${locator}    ${expected}

Windows Element Name Should Eventually Be
    [Arguments]    ${locator}    ${expected}
    ${actual} =    Get Name From Element    ${locator}
    Should Be Equal As Strings    ${actual}    ${expected}

Windows Element Should Be Visible
    [Arguments]    ${locator}
    Wait Until Element Exist    ${locator}

Capture Windows Failure Screenshot
    Take Screenshot
