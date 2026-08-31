*** Settings ***
Documentation    Page Object for https://testpages.eviltester.com/pages/forms/html-form/
...              Contains only locators and behaviour specific to this single page.
...              Generic browser actions are delegated to RESOURCES/UTILS/web_utils.resource.
Resource         ../../UTILS/web_utils.resource
Library          Collections

*** Variables ***
${HTML_FORM_URL}                https://testpages.eviltester.com/pages/forms/html-form/

${USERNAME_FIELD}                input[name="username"]
${PASSWORD_FIELD}                input[name="password"]
${COMMENTS_FIELD}                textarea[name="comments"]
${CHECKBOX_1}                    input[name="checkboxes[]"][value="cb1"]
${CHECKBOX_2}                    input[name="checkboxes[]"][value="cb2"]
${CHECKBOX_3}                    input[name="checkboxes[]"][value="cb3"]
${RADIO_1}                       input[name="radioval"][value="rd1"]
${RADIO_2}                       input[name="radioval"][value="rd2"]
${RADIO_3}                       input[name="radioval"][value="rd3"]
${MULTI_SELECT}                  select[name="multipleselect[]"]
${DROPDOWN}                      select[name="dropdown"]
${SUBMIT_BUTTON}                 input[name="submitbutton"][value="submit"]
${CANCEL_BUTTON}                 input[name="submitbutton"][value="cancel"]

*** Keywords ***
Open Html Form Page
    Open Browser To Page    ${HTML_FORM_URL}

Reload Html Form Page
    [Documentation]    Navigates back to a clean copy of the page using the already open browser.
    Go To Url    ${HTML_FORM_URL}

Fill Username
    [Arguments]    ${username}
    Input Text To Field    ${USERNAME_FIELD}    ${username}

Fill Password
    [Arguments]    ${password}
    Input Text To Field    ${PASSWORD_FIELD}    ${password}

Fill Comments
    [Arguments]    ${comments}
    Input Text To Field    ${COMMENTS_FIELD}    ${comments}

Select Checkbox Item
    [Documentation]    ${item} is 1, 2 or 3, matching "Checkbox 1/2/3" on the page.
    [Arguments]    ${item}
    Check Checkbox By Selector    input[name="checkboxes[]"][value="cb${item}"]

Select Radio Item
    [Documentation]    ${item} is 1, 2 or 3, matching "radio 1/2/3" on the page.
    [Arguments]    ${item}
    Select Radio Button By Selector    input[name="radioval"][value="rd${item}"]

Select Dropdown Item
    [Documentation]    ${item} is 1-6, matching "Drop Down Item 1-6".
    [Arguments]    ${item}
    Select Dropdown Option By Value    ${DROPDOWN}    dd${item}

Select Multiple Select Items
    [Documentation]    ${items} are 1-4, matching "Selection Item 1-4".
    [Arguments]    @{items}
    ${values} =    Create List
    FOR    ${item}    IN    @{items}
        Append To List    ${values}    ms${item}
    END
    Select Multiple Options By Value    ${MULTI_SELECT}    @{values}

Submit Form
    Click Element    ${SUBMIT_BUTTON}

Cancel Form
    Click Element    ${CANCEL_BUTTON}

Html Form Page Should Be Open
    Element Should Be Visible    ${USERNAME_FIELD}

Form Should Have Been Submitted
    [Documentation]    The demo site POSTs to a "submit" sub-path and echoes the result there.
    Current Url Should Contain    /pages/forms/html-form/submit
