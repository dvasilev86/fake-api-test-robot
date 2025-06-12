*** Settings ***
Library            RequestsLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Delete Author By Id Template
Suite Setup        Setup Suite
Default Tags       Authors  Delete Author by Id


*** Test Cases ***
Delete Author By Valid Id  1  200
Delete Author By Negative Id  -1  404
Delete Author By Non-integer Id  invalid  400
Delete Author By Very Large Id   ${LARGE_INT_VALUE}  400
Delete Author Without Providing Id  ${EMPTY}  200

*** Keywords ***
Setup Suite
    # normally, deletion relies on creating a new piece of test data, specifically available to be deleted
    # this process should be done on a test basis and should be cleaned up in case the execution fails
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    delete author by id  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Delete Author By Id Template
    [Arguments]    ${id}  ${expected_status}  ${expected_message}=${EMPTY}
    DELETE On Session    alias=${session}  url=${AUTHORS_URL}${id}  expected_status=${expected_status}