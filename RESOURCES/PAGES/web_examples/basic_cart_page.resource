*** Settings ***
Resource    ../../UTILS/web_utils.resource

*** Variables ***
${BASIC_CART_URL}    https://testpages.eviltester.com/apps/basiccart/
${PRODUCT_LIST}      main
${ADD_TO_CART_BUTTON}    main button.add >> nth=0
${CART_COUNT}        .cart-count, [data-testid="cart-count"]

*** Keywords ***
Open Basic Cart Page
    Open Browser To Page    ${BASIC_CART_URL}

Basic Cart Page Should Be Open
    Page Should Have Heading    BasicStore Products
    Element Should Be Visible    ${ADD_TO_CART_BUTTON}

Add First Product To Cart
    Click Element    ${ADD_TO_CART_BUTTON}

Shopping Cart Link Should Be Visible
    Element Text Should Contain    main    Add to Cart