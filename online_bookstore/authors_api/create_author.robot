*** Settings ***
Library            RequestsLibrary
Library            JSONLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Create Author Template
Suite Setup        Setup Suite
Default Tags       Authors  Create Author

*** Test Cases ***
Create Author With Valid Data  ${EMPTY}  ${EMPTY}  200
Create Author Validation: Existing Id  $.id  ${1}  400  Skip: will fail if executed, probably because of fake data. in general, "id" payload in POST requests is an oddity
Create Author Validation: Empty First Name  $.firstName  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Create Author Validation: Empty Last Name  $.lastName  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Create Author Validation: Too Long First Name  $.firstName  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Author Validation: Too Long Last Name  $.lastName  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Author Validation: Negative Book Id  $.idBook  ${-1}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Author Validation: Too Large Book Id  $.idBook  ${LARGE_INT_VALUE}    400
Create Author Validation: Invalid Book Id Type  $.idBook  invalid    400

*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    create author  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Create Author Template
    [Arguments]    ${replace_field}  ${replace_value}  ${expected_status}  ${skip_message}=${EMPTY}
    Skip if  '${skip_message}' != '${EMPTY}'  ${skip_message}
    ${request}=  Load JSON From File  ${CURDIR}/../common/json_objects/create_author.json

    IF  '${replace_field}' != '${EMPTY}'
        ${request}=  Update Value To Json    ${request}  ${replace_field}  ${replace_value}
    END

    POST On Session    alias=${session}  url=${AUTHORS_URL}  json=${request}  expected_status=${expected_status}