*** Settings ***
Library            RequestsLibrary
Library            JSONLibrary
Library            String
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Update Book Template
Suite Setup        Setup Suite
Default Tags       Books  Update Book

*** Test Cases ***
Update Book With Valid Id  1  ${EMPTY}  ${EMPTY}  200
Update Book With Non-existing Id  999999  ${EMPTY}  ${EMPTY}  404     Skip: the fake API treats all integer IDs as valid, hence this test fails
Update Book With Invalid Id  -1  ${EMPTY}  ${EMPTY}  404    Skip: the fake API treats all integer IDs as valid, hence this test fails
Update Book With Non-integer Id  invalid  ${EMPTY}  ${EMPTY}  400       
Update Book With Too Large Id  ${LARGE_INT_VALUE}  ${EMPTY}  ${EMPTY}  400     
Update Book Without Providing Id  ${EMPTY}  ${EMPTY}  ${EMPTY}  405
Update Book Validation: Empty Title  1  $.title  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Update Book Validation: Empty Description  1  $.description  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Update Book Validation: Empty Excerpt  1  $.excerpt  ${EMPTY}    200  # described schema allows for null value so the expectation is 200
Update Book Validation: Too Long Title  1  $.title  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Book Validation: Too Long Description  1  $.description  ${1000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Book Validation: Too Long Excerpt  1  $.excerpt  ${5000_CHARS}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Book Validation: Negative Page Count  1  $.pageCount  ${-1}    400  Skip: this expectation is not documented, only added as boundary value test, which currently will fail
Update Book Validation: Too Large Page Count  1  $.pageCount  ${LARGE_INT_VALUE}    400
Update Book Validation: Empty Publish Date  1  $.publishDate  ${EMPTY}    400
Update Book Validation: Invalid Publish Date  1  $.publishDate  invalid    400

*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    Update book  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Update Book Template
    [Arguments]    ${book_id}  ${replace_field}  ${replace_value}  ${expected_status}  ${skip_message}=${EMPTY}
    Skip if  '${skip_message}' != '${EMPTY}'  ${skip_message}
    ${request}=  Load JSON From File  ${CURDIR}/../common/json_objects/create_book.json
    IF  '${replace_field}' != '${EMPTY}'
        ${request}=  Update Value To Json    ${request}  ${replace_field}  ${replace_value}
    END
    ${response}=  PUT On Session    alias=${session}  url=${BOOKS_URL}${book_id}  json=${request}  expected_status=${expected_status}
    
    # normally, some check would be performed if the update actually took place
    # since we use fake API, the data is not actually updated and some checks cannot be performed
    # below, we only check the response of the PUT call, not the actual data (with GET other means like direct DB check)
    ${field}=  Remove String  ${replace_field}  $.
    IF  '${replace_field}' != '${EMPTY}' and '${expected_status}' == '200'
        Should Be Equal    ${response.json()}[${field}]  ${replace_value}
    END