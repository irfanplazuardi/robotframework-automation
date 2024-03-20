*** Settings ***
Resource    ../constant/app_variables.robot
Resource    ../resources/keywords/session_keyword.robot
Resource    ../resources/path/path_schema.robot
Library    JSONLibrary
Library    DateTime

*** Test Cases ***
Get List Users Per Page
    Create Session With Headers    GET_USER
    ${params}    Create Dictionary    page=1
    ${response}    GET On Session     GET_USER    /api/users?      params=${params}
    Log    ${response.content}
    Status Should Be   200
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${USER_SCHEMA}

    ${page}    Set Variable    ${json_data['page']}
    ${per_page}    Set Variable    ${json_data['per_page']}
    ${total}    Set Variable    ${json_data['total']}
    ${total_pages}    Set Variable    ${json_data['total_pages']}
    ${data_length1}    Get Length    ${json_data['data']}
    ${data_id}    Set Variable    ${json_data['data'][0]['id']}
    ${data_email}    Set Variable    ${json_data['data'][0]['email']}
    ${data_first_name}    Set Variable    ${json_data['data'][0]['first_name']}
    ${data_last_name}    Set Variable    ${json_data['data'][0]['last_name']}
    ${data_avatar}    Set Variable    ${json_data['data'][0]['avatar']}

    Should Be Equal As Integers    ${page}    ${params['page']}
    Should Be Equal As Integers    ${per_page}    ${data_length1}
    Should Be Equal As Integers    ${data_id}    1
    Should Be Equal As Strings    ${data_email}    george.bluth@reqres.in
    Should Be Equal As Strings    ${data_first_name}    George
    Should Be Equal As Strings    ${data_last_name}    Bluth
    Should Be Equal As Strings    ${data_avatar}    https://reqres.in/img/faces/1-image.jpg
    
    # page 2
    ${params2}    Create Dictionary    page=2
    ${response2}    GET On Session     GET_USER    /api/users?   params=${params2}
    Log    ${response2.content}
    Status Should Be   200
    ${json_data2}   Set Variable    ${response2.json()} 
    Validate Json By Schema File    ${json_data2}    ${USER_SCHEMA}

    ${page2}    Set Variable    ${json_data2['page']}
    ${data_length2}    Get Length    ${json_data2['data']}
    ${sum_page}    Evaluate    ${data_length1}+${data_length2}

    ${data_id2}    Set Variable    ${json_data2['data'][5]['id']}
    ${data_email2}    Set Variable    ${json_data2['data'][5]['email']}
    ${data_first_name2}    Set Variable    ${json_data2['data'][5]['first_name']}
    ${data_last_name2}    Set Variable    ${json_data2['data'][5]['last_name']}
    ${data_avatar2}    Set Variable    ${json_data2['data'][5]['avatar']}

    
    Should Be Equal As Integers    ${page2}    ${params2['page']}
    Should Be Equal As Integers    ${per_page}    ${data_length2}
    Should Be Equal As Integers    ${total}       ${sum_page}
    Should Be Equal As Integers    ${data_id2}    12
    Should Be Equal As Strings    ${data_email2}    rachel.howell@reqres.in
    Should Be Equal As Strings    ${data_first_name2}    Rachel
    Should Be Equal As Strings    ${data_last_name2}    Howell
    Should Be Equal As Strings    ${data_avatar2}    https://reqres.in/img/faces/12-image.jpg

    #page 3
    ${params3}    Create Dictionary    page=3
    ${response3}    GET On Session     GET_USER    /api/users?    params=${params3}
    Log    ${response3.content}
    Status Should Be   200
    ${json_data3}   Set Variable    ${response3.json()} 
    Validate Json By Schema File    ${json_data3}    ${USER_SCHEMA}
    ${page3}    Set Variable    ${json_data3['page']}
    ${data_length3}    Get Length    ${json_data3['data']}

    Should Be Equal As Integers    ${page3}    ${params3['page']}
    Should Be Equal As Integers   ${data_length3}    0

Get Single User
    Create Session With Headers    GET_USER
    ${params}    Set Variable    2
    ${response}    GET On Session     GET_USER    /api/users/${params}
    Log    ${response.content}
    Status Should Be   200
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${SINGLE_USER_SCHEMA}

    ${data_id}    Set Variable    ${json_data['data']['id']}
    ${data_email}    Set Variable    ${json_data['data']['email']}
    ${data_first_name}    Set Variable    ${json_data['data']['first_name']}
    ${data_last_name}    Set Variable    ${json_data['data']['last_name']}
    ${data_avatar}    Set Variable    ${json_data['data']['avatar']}

    Should Be Equal As Integers    ${data_id}    ${params}
    Should Be Equal As Strings    ${data_email}    janet.weaver@reqres.in
    Should Be Equal As Strings    ${data_first_name}    Janet
    Should Be Equal As Strings    ${data_last_name}    Weaver
    Should Be Equal As Strings    ${data_avatar}    https://reqres.in/img/faces/2-image.jpg

Get Single User With Invalid ID
    Create Session With Headers    GET_USER
    ${params}    Set Variable    13
    ${response}    GET On Session     GET_USER    /api/users/${params}    expected_status=404
    Log    ${response.content}
    Status Should Be   404
    ${json_data}   Set Variable    ${response.json()} 
    Should Be Empty    ${json_data}

Create New User 
    Create Session With Headers    POST_USER
    ${payload}    Create Dictionary    name="johnss"    job="QA"   
    ${response}    POST On Session     POST_USER    /api/users   json=${payload} 
    Log    ${response.content}
    Status Should Be   201
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${CREATE_USER_SCHEMA}

    ${name}    Set Variable    ${json_data['name']}
    ${job}    Set Variable    ${json_data['job']}
    ${created_at}    Set Variable    ${json_data['createdAt']}
    ${current_date}    Get Current Date    result_format=%Y-%m-%d

    Should Be Equal As Strings    ${name}    ${payload['name']}
    Should Be Equal As Strings    ${job}    ${payload['job']}
    Should Contain    ${created_at}    ${current_date}

Update User With Put
    Create Session With Headers    PUT_USER
    ${payload}    Create Dictionary    name="messi"    job="director" 
    ${paramater}  Set Variable    2
    ${response}    PUT On Session     PUT_USER    /api/users/${paramater}   json=${payload} 
    Log    ${response.content}
    Status Should Be   200
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${UPDATE_USER_SCHEMA}

    ${name}    Set Variable    ${json_data['name']}
    ${job}    Set Variable    ${json_data['job']}
    ${updated_at}    Set Variable    ${json_data['updatedAt']}
    ${current_date}    Get Current Date    result_format=%Y-%m-%d

    Should Be Equal As Strings    ${name}    ${payload['name']}
    Should Be Equal As Strings    ${job}    ${payload['job']}
    Should Contain    ${updated_at}    ${current_date}

Update User With Patch
    Create Session With Headers    PATCH_USER
    ${payload}    Create Dictionary    name="messi"    job="director" 
    ${paramater}  Set Variable    2
    ${response}    PATCH On Session     PATCH_USER    /api/users/${paramater}   json=${payload} 
    Log    ${response.content}
    Status Should Be   200
    ${json_data}   Set Variable    ${response.json()} 
    Validate Json By Schema File    ${json_data}    ${UPDATE_USER_SCHEMA}

    ${name}    Set Variable    ${json_data['name']}
    ${job}    Set Variable    ${json_data['job']}
    ${updated_at}    Set Variable    ${json_data['updatedAt']}
    ${current_date}    Get Current Date    result_format=%Y-%m-%d

    Should Be Equal As Strings    ${name}    ${payload['name']}
    Should Be Equal As Strings    ${job}    ${payload['job']}
    Should Contain    ${updated_at}    ${current_date}
    
Delete User
    Create Session With Headers    DELETE_USER
    ${paramater}  Set Variable    2
    ${response}    DELETE On Session     DELETE_USER    /api/users/${paramater}   
    Log    ${response.content}
    Status Should Be   204
    Should Be Empty    ${response.content}
    
    


    

    


