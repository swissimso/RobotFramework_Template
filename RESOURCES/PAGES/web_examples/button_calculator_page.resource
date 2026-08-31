*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${BUTTON_CALCULATOR_URL}    https://testpages.eviltester.com/apps/button-calculator/
${DIGIT_ONE}                main button:has-text("1") >> nth=0
${PLUS}                     main button:has-text("+") >> nth=0
${EQUALS}                   main button:has-text("=") >> nth=0
${CLEAR}                    main button:has-text("AC") >> nth=0

*** Keywords ***
Open Button Calculator Page
    Open Browser To Page    ${BUTTON_CALCULATOR_URL}

Button Calculator Page Should Be Open
    Page Should Have Heading    Button Calculator
    Element Should Be Visible    ${DIGIT_ONE}

Calculate One Plus One
    Click Element    ${DIGIT_ONE}
    Click Element    ${PLUS}
    Click Element    ${DIGIT_ONE}
    Click Element    ${EQUALS}

Clear Button Calculator
    Click Element    ${CLEAR}