*** Settings ***
Variables    ${CURDIR}/common/env_vars.py

*** Variables ***
${BASE_URL}=  ${app_url}[${env}]
${BOOKS_URL}=  /api/v1/Books/
${AUTHORS_URL}=  /api/v1/Authors/
${AUTHORS_PER_BOOK_ID_URL}=  ${AUTHORS_URL}authors/books/