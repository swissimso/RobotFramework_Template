*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/basic_cart_page.resource
Test Tags         web    apps    cart
Suite Setup       Open Basic Cart Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Basic Cart Page Loads
    [Tags]    REQ-WEB-CART-001
    Basic Cart Page Should Be Open

Product Can Be Added To Cart
    [Tags]    REQ-WEB-CART-002
    Add First Product To Cart
    Shopping Cart Link Should Be Visible