*** Settings ***
Documentation    Generic, reusable browser keywords built on top of the Browser (Playwright)
...              library. No test or page should import Browser directly - everything goes
...              through this UTILS layer so the underlying automation engine can be swapped
...              out later without touching PAGES or TESTS.
...
...              NOTE: on keyword failure, Browser automatically saves a screenshot to
...              ${OUTPUTDIR}/browser/screenshot/ and links it into log.html under the failed
...              keyword. highlight_on_failure=True additionally draws a border around the
...              selector that failed, so the screenshot shows exactly what could not be found.
Library          Browser    highlight_on_failure=True
Resource         ../config.resource

*** Variables ***
${BROWSER}          chromium
${DEFAULT_TIMEOUT}  10s

*** Keywords ***
Open Browser To Page
    [Documentation]    Starts a new browser, context and page, and navigates to ${url}.
    [Arguments]    ${url}    ${browser}=${BROWSER}    ${headless}=${HEADLESS}
    New Browser    browser=${browser}    headless=${headless}
    New Context    viewport={'width': 1600, 'height': 900}
    New Page    ${url}    wait_until=domcontentloaded

Go To Url
    [Arguments]    ${url}
    Go To    ${url}

Close All Test Browsers
    Close Browser    ALL

Click Element
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible    timeout=${DEFAULT_TIMEOUT}
    Click    ${selector}

Input Text To Field
    [Documentation]    Clears the field before typing to keep the action idempotent.
    [Arguments]    ${selector}    ${text}
    Wait For Elements State    ${selector}    visible    timeout=${DEFAULT_TIMEOUT}
    Fill Text    ${selector}    ${text}

Get Element Text
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible    timeout=${DEFAULT_TIMEOUT}
    ${text} =    Get Text    ${selector}
    RETURN    ${text}

Element Text Should Be
    [Arguments]    ${selector}    ${expected}
    Get Text    ${selector}    ==    ${expected}

Element Text Should Contain
    [Arguments]    ${selector}    ${expected}
    ${text} =    Get Element Text    ${selector}
    Should Contain    ${text}    ${expected}

Page Should Have Heading
    [Arguments]    ${heading}
    Element Text Should Contain    main h1    ${heading}

Element Should Be Enabled
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    enabled    timeout=${DEFAULT_TIMEOUT}

Select Dropdown Option By Value
    [Arguments]    ${selector}    ${value}
    Select Options By    ${selector}    value    ${value}

Select Multiple Options By Value
    [Arguments]    ${selector}    @{values}
    Select Options By    ${selector}    value    @{values}

Check Checkbox By Selector
    [Arguments]    ${selector}
    Check Checkbox    ${selector}

Uncheck Checkbox By Selector
    [Arguments]    ${selector}
    Uncheck Checkbox    ${selector}

Select Radio Button By Selector
    [Arguments]    ${selector}
    Click Element    ${selector}

Element Should Be Visible
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible    timeout=${DEFAULT_TIMEOUT}

Current Url Should Contain
    [Arguments]    ${expected_part}
    ${url} =    Get Url
    Should Contain    ${url}    ${expected_part}
