*** Settings ***
Library        RequestsLibrary
Resource       ${CURDIR}/../api_paths.resource
Default Tags   Books  Fetch All Books

*** Test Cases ***
Get All Books
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    get all books  ${BASE_URL}  headers=${headers}  disable_warnings=1
    GET On Session    alias=${session}  url=${BOOKS_URL}  expected_status=200