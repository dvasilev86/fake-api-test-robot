*** Settings ***
Library            RequestsLibrary
Library            JSONLibrary
Library            String
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Update Author Template
Suite Setup        Setup Suite
Default Tags       Authors  Update Author

*** Test Cases ***
Update Author With Valid Data  ${1}  ${EMPTY}  ${EMPTY}  200
Update Author With Non-existing Id  999999  ${EMPTY}  ${EMPTY}  404     Skip: the fake API treats all integer IDs as valid, hence this test fails
Update Author With Negative Id  -1  ${EMPTY}  ${EMPTY}  404    Skip: the fake API treats all integer IDs as valid, hence this test fails
Update Author With Non-integer Id  invalid  ${EMPTY}  ${EMPTY}  400
Update Author With Too Large Id  ${LARGE_INT_VALUE}  ${EMPTY}  ${EMPTY}  400
Update Author Without Providing Id  ${EMPTY}  ${EMPTY}  ${EMPTY}  405
Update Author Validation: Empty First Name  ${1}  $.firstName  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Update Author Validation: Empty Last Name  ${1}  $.lastName  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Update Author Validation: Too Long First Name  ${1}  $.firstName  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Author Validation: Too Long Last Name  ${1}  $.lastName  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Author Validation: Negative Book Id  ${1}  $.idBook  ${-1}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Author Validation: Too Large Book Id  ${1}  $.idBook  ${LARGE_INT_VALUE}    400
Update Author Validation: Invalid Book Id Type  ${1}  $.idBook  invalid    400

*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    Update Author  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Update Author Template
    [Arguments]    ${author_id}  ${replace_field}  ${replace_value}  ${expected_status}  ${skip_message}=${EMPTY}
    Skip if  '${skip_message}' != '${EMPTY}'  ${skip_message}
    ${request}=  Load JSON From File  ${CURDIR}/../common/json_objects/create_author.json
    IF  '${replace_field}' != '${EMPTY}'
        ${request}=  Update Value To Json    ${request}  ${replace_field}  ${replace_value}
    END
    ${response}=  PUT On Session    alias=${session}  url=${AUTHORS_URL}${author_id}  json=${request}  expected_status=${expected_status}
    
    # normally, some check would be performed if the update actually took place
    # since we use fake API, the data is not actually updated and some checks cannot be performed
    # below, we only check the response of the PUT call, not the actual data (with GET other means like direct DB check)
    ${field}=  Remove String  ${replace_field}  $.
    IF  '${replace_field}' != '${EMPTY}' and '${expected_status}' == '200'
        Should Be Equal    ${response.json()}[${field}]  ${replace_value}
    END