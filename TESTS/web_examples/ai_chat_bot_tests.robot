*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/ai_chat_bot_page.resource
Test Tags         web    apps    ai
Suite Setup       Open AI Chat Bot Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
AI Chat Bot Page Loads
    [Tags]    REQ-WEB-AI-001
    AI Chat Bot Page Should Be Open

Chat Can Be Reset
    [Tags]    REQ-WEB-AI-002
    Reset AI Chat