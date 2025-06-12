*** Settings ***
Library            RequestsLibrary
Library            JSONLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Create Book Template
Suite Setup        Setup Suite
Default Tags       Books  Create Book

*** Test Cases ***
Create Book With Valid Data  ${EMPTY}  ${EMPTY}  200
Create Book Validation: Existing Id  $.id  ${1}  400  Skip: will fail if executed, probably because of fake data. in general, "id" payload in POST requests is an oddity
Create Book Validation: Empty Title  $.title  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Create Book Validation: Empty Description  $.description  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Create Book Validation: Empty Excerpt  $.excerpt  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Create Book Validation: Too Long Title  $.title  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Book Validation: Too Long Description  $.description  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Book Validation: Too Long Excerpt  $.excerpt  ${5000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Book Validation: Negative Page Count  $.pageCount  ${-1}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Create Book Validation: Too Large Page Count  $.pageCount  ${LARGE_INT_VALUE}    400
Create Book Validation: Empty Publish Date  $.publishDate  ${EMPTY}    400
Create Book Validation: Invalid Publish Date  $.publishDate  invalid    400

*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    create book  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Create Book Template
    [Arguments]    ${replace_field}  ${replace_value}  ${expected_status}  ${skip_message}=${EMPTY}
    Skip if  '${skip_message}' != '${EMPTY}'  ${skip_message}
    ${request}=  Load JSON From File  ${CURDIR}/../common/json_objects/create_book.json
    
    IF  '${replace_field}' != '${EMPTY}'
        ${request}=  Update Value To Json    ${request}  ${replace_field}  ${replace_value}
    END

    POST On Session    alias=${session}  url=${BOOKS_URL}  json=${request}  expected_status=${expected_status}