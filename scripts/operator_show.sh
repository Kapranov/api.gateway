#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAAEBvdUk2YTJBV3Y2QnFMWVd6NTdXM3luVnpxVnVjMG5pTHBpbXJFU0dVNlM3bFVjcGMySHFaWUk2bHhaZWtiZ3Y4bgYAsEpk8IoBYgABUYA.zcP0xJ8t_jrZydwXqxrMo1v6bRSymkNL0E4rYG8Ob74"
URL="http://taxgig.me:4000"

generate_data() {
cat << EOF
id: "AaQ2XT6EmAIR80nxej"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="query { showOperator($(generate_data)) { id active config { id contentType parameters { id key value insertedAt updatedAt } name size url insertedAt updatedAt } limitCount smsLogs { id priority } nameOperator phoneCode priceExt priceInt priority operatorType { id active nameType priority insertedAt insertedAt } insertedAt updatedAt } }" \
     ${URL}
