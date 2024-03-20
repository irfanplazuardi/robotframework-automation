*** Settings ***
Resource    ../../configs/environment.robot
Library    RequestsLibrary

*** Keywords ***
Create Session With Headers    [Arguments]    ${session_name}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    ${session_name}    ${BASE_URL}   headers=${headers}     verify=true