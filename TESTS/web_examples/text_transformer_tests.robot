*** Settings ***
Resource          ../../RESOURCES/PAGES/web_examples/text_transformer_page.resource
Test Tags         web    apps    transformation
Suite Setup       Open Text Transformer Page
Suite Teardown    Close All Test Browsers

*** Test Cases ***
Text Transformer Page Loads
    [Tags]    REQ-WEB-TRANSFORMER-001
    Text Transformer Page Should Be Open

Text Is Transformed
    [Tags]    REQ-WEB-TRANSFORMER-002
    Transform Text    Robot
    Reverse Transformation Should Be Shown    toboR