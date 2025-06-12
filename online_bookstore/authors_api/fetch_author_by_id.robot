*** Settings ***
Library            RequestsLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Get Author By Id Template
Suite Setup        Setup Suite
Default Tags       Authors  Fetch Author by Id


*** Test Cases ***
Get Author By Valid Id  1  200
Get Author By Non-existing Id  999999  404
Get Author By Negative Id  -1  404
Get Author By Non-integer Id  invalid  400
Get Author By Very Large Id   ${LARGE_INT_VALUE}  400
Get Author Without Providing Id  ${EMPTY}  200  # falls back to "fetch all Authors", so result is 200



*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    get Author by id  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Get Author By Id Template
    [Arguments]    ${id}  ${expected_status}  ${expected_message}=${EMPTY}
    GET On Session    alias=${session}  url=${AUTHORS_URL}${id}  expected_status=${expected_status}