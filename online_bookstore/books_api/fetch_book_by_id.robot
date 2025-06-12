*** Settings ***
Library            RequestsLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Get Book By Id Template
Suite Setup        Setup Suite
Default Tags       Books  Fetch Book by Id


*** Test Cases ***
Get Book By Valid Id  1  200
Get Book By Non-existing Id  999999  404
Get Book By Invalid Id  -1  404
Get Book By Non-integer Id  invalid  400
Get Book By Very Large Id   ${LARGE_INT_VALUE}  400
Get Book Without Providing Id  ${EMPTY}  200  # falls back to "fetch all books", so result is 200



*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    get book by id  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Get Book By Id Template
    [Arguments]    ${id}  ${expected_status}  ${expected_message}=${EMPTY}
    GET On Session    alias=${session}  url=${BOOKS_URL}${id}  expected_status=${expected_status}