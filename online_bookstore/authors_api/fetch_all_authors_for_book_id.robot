*** Settings ***
Library            RequestsLibrary
Resource           ${CURDIR}/../api_paths.resource
Resource           ${CURDIR}/../common/helpers.resource
Test Template      Get Authors By Book Id Template
Suite Setup        Setup Suite
Default Tags       Authors  Fetch Authors per Book Id


*** Test Cases ***
Get Authors By Valid Book Id  ${1}  200
Get Authors By Non-existing Book Id  999999  404
Get Authors By Negative Integer Book Id  -1  404
Get Authors By Non-integer Book Id  invalid  400
Get Authors By Very Large Book Id   ${LARGE_INT_VALUE}  400
Get Authors Without Providing Book Id  ${EMPTY}  404



*** Keywords ***
Setup Suite
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    get author by book id  ${BASE_URL}  headers=${headers}  disable_warnings=1
    Set Suite Variable    ${session}

Get Authors By Book Id Template
    [Arguments]    ${book_id}  ${expected_status}  ${expected_message}=${EMPTY}
    # the call seems to respond with random authors number (2-4) each time, regardless of the book id provided, so long as it's valid
    ${response}=  GET On Session    alias=${session}  url=${AUTHORS_PER_BOOK_ID_URL}${book_id}  expected_status=${expected_status}

    IF  '${expected_status}' == '200'        
        ${authors}=  Get Length    ${response.json()}
        Should Be True    ${authors} > 0

        # verify the authors are actually assigned to the requested book id
        FOR  ${author}  IN  @{response.json()}
            Log  ${author}
            Should Be True    ${author}[idBook] == ${book_id}
        END
    END
