*** Settings ***
Library            RequestsLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Delete Book By Id Template
Suite Setup        Setup Suite
Default Tags       Books  Delete Book by Id


*** Test Cases ***
Delete Book By Valid Id  1  200
Delete Book By Invalid Id  -1  404
Delete Book By Non-integer Id  invalid  400
Delete Book By Very Large Id   ${LARGE_INT_VALUE}  400
Delete Book Without Providing Id  ${EMPTY}  200

*** Keywords ***
Setup Suite
    # normally, deletion relies on creating a new piece of test data, specifically available to be deleted
    # this process should be done on a test basis and should be cleaned up in case the execution fails
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    delete book by id  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Delete Book By Id Template
    [Arguments]    ${id}  ${expected_status}  ${expected_message}=${EMPTY}
    GET On Session    alias=${session}  url=${BOOKS_URL}${id}  expected_status=${expected_status}