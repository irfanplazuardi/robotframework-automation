*** Settings ***
Resource    ../constant/app_variables.robot
Resource    ../resources/keywords/session_keyword.robot
Resource    ../resources/path/path_schema.robot
Library    JSONLibrary

*** Test Cases ***
Successfull Login With Valid Email And Password
    Create Session With Headers    login
    ${payload}    Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    ${response}    POST On Session     login    /api/login    json=${payload}
    Log    ${response.content}
    Status Should Be   200
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${LOGIN_SCHEMA}

    ${result_token}    Set Variable    ${json_data['token']}

    Should Be Equal As Strings    ${result_token}    ${TOKEN}

Unsuccessfull Login With Email Only
    Create Session With Headers    login
    ${payload}    Create Dictionary    email=${EMAIL}    
    ${response}   POST On Session    login    /api/login    json=${payload}     expected_status=400      
    Log    ${response.content}
    Status Should Be    400
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${ERROR_LOGIN_SCHEMA}

    ${error_message}    Set Variable    ${json_data['error']}
   
    Should Be Equal As Strings    ${error_message}    Missing password

Unsuccessfull Login With Password Only
    Create Session With Headers    login
    ${payload}    Create Dictionary    password=${PASSWORD}    
    ${response}   POST On Session    login    /api/login    json=${payload}     expected_status=400
    Log    ${response.content}
    Status Should Be    400
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${ERROR_LOGIN_SCHEMA}

    ${error_message}    Set Variable    ${json_data['error']}
   
    Should Be Equal As Strings    ${error_message}    Missing email or username

Unsuccessfull Login With Invalid Email
    Create Session With Headers    login
    ${payload}    Create Dictionary    email=${INVALID_EMAIL}   password=${PASSWORD}    
    ${response}   POST On Session    login    /api/login    json=${payload}     expected_status=400
    Log    ${response.content}
    Status Should Be    400
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${ERROR_LOGIN_SCHEMA}

    ${error_message}    Set Variable    ${json_data['error']}
   
    Should Be Equal As Strings    ${error_message}    user not found