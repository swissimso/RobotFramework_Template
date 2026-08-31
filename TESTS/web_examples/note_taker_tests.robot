*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/note_taker_page.resource
Test Tags         web    apps    storage
Suite Setup       Open Note Taker Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Note Taker Page Loads
    [Tags]    REQ-WEB-NOTES-001
    Note Taker Page Should Be Open

Note Can Be Added And Shown
    [Tags]    REQ-WEB-NOTES-002
    Add Note    Robot note    Page object test
    Show Notes
    Clear All Notes