*** Settings ***
Library        RequestsLibrary
Resource       ${CURDIR}/../api_paths.resource
Default Tags   Authors  Fetch All Authors

*** Test Cases ***
Get All Authors
    ${headers}=  Create Dictionary    Content-Type  application/json
    ${session}=  Create Session    get all authors  ${BASE_URL}  headers=${headers}  disable_warnings=1
    GET On Session    alias=${session}  url=${AUTHORS_URL}  expected_status=200