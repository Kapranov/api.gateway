#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAAEBvdUk2YTJBV3Y2QnFMWVd6NTdXM3luVnpxVnVjMG5pTHBpbXJFU0dVNlM3bFVjcGMySHFaWUk2bHhaZWtiZ3Y4bgYAsEpk8IoBYgABUYA.zcP0xJ8t_jrZydwXqxrMo1v6bRSymkNL0E4rYG8Ob74"
URL="http://taxgig.me:4000"

generate_data() {
cat << EOF
active: true
limitCount: 44
nameOperator: "Kaufman"
operatorTypeId: "AaOWJmyvdMmilLRfeK"
phoneCode: "+380999999999"
priceExt: "0.11"
priceInt: "0.11"
priority: 11
config: {
contentType: "Aloha!"
name: "Honolulu"
size: 11
url: "some text for url"
parameters: {
key: "some text"
value: "some text"
}}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="mutation { createOperator($(generate_data)) { id active config { id contentType parameters { id key value insertedAt updatedAt } name size url insertedAt updatedAt } limitCount smsLogs { id priority } nameOperator phoneCode priceExt priceInt priority operatorType { id active nameType priority insertedAt insertedAt } insertedAt updatedAt } }" \
     ${URL}
