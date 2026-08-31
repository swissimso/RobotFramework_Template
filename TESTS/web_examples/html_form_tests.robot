*** Settings ***
Documentation    Test suite (one file = one suite) for the eviltester HTML Form practice page.
...              Strategy: one suite per page/feature under TESTS/web_examples, each test case is a
...              single user scenario built purely from PAGE keywords - never raw selectors.
Resource         ../../RESOURCES/PAGES/web_examples/html_form_page.resource
Test Tags        web    smoke
Suite Setup      Open Html Form Page
Suite Teardown   Close All Test Browsers
Test Setup       Reload Html Form Page

*** Test Cases ***
Html Form Page Should Load
    [Tags]    REQ-WEB-HTMLFORM-001
    [Documentation]    Basic smoke test that the page and its main field are reachable.
    Html Form Page Should Be Open

Fill In Basic Text Fields
    [Tags]    REQ-WEB-HTMLFORM-002
    Fill Username    john.doe
    Fill Password    Sup3rSecret!
    Fill Comments    Automated with Robot Framework and the Browser library.

Select Checkbox And Radio Items
    [Tags]    REQ-WEB-HTMLFORM-003
    Select Checkbox Item    2
    Select Radio Item       3

Select Dropdown And Multi Select Items
    [Tags]    REQ-WEB-HTMLFORM-004
    Select Dropdown Item          5
    Select Multiple Select Items  1    3

Submit The Form
    [Tags]    REQ-WEB-HTMLFORM-005
    [Documentation]    End to end check that submitting the form navigates to the results page.
    Fill Username    john.doe
    Fill Password    Sup3rSecret!
    Submit Form
    Form Should Have Been Submitted
