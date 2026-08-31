*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${AI_CHAT_URL}       https://testpages.eviltester.com/apps/ai-chat-bot/
${QUESTION_FIELD}    main textarea, main input[type="text"]
${ASK_BUTTON}        main button:has-text("Ask")
${RESET_BUTTON}      main button:has-text("Reset Chat")

*** Keywords ***
Open AI Chat Bot Page
    Open Browser To Page    ${AI_CHAT_URL}

AI Chat Bot Page Should Be Open
    Page Should Have Heading    AI Chat Bot
    Element Should Be Visible    ${QUESTION_FIELD}

Ask Shopping Cart Question
    [Arguments]    ${question}
    Input Text To Field    ${QUESTION_FIELD}    ${question}
    Click Element    ${ASK_BUTTON}

Reset AI Chat
    Click Element    ${RESET_BUTTON}