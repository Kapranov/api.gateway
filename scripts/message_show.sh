#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAAEBvdUk2YTJBV3Y2QnFMWVd6NTdXM3luVnpxVnVjMG5pTHBpbXJFU0dVNlM3bFVjcGMySHFaWUk2bHhaZWtiZ3Y4bgYAsEpk8IoBYgABUYA.zcP0xJ8t_jrZydwXqxrMo1v6bRSymkNL0E4rYG8Ob74"
URL="http://taxgig.me:4000"

generate_data() {
cat << EOF
id: "AaQPUvwnOwn54wymDQ"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="query { showMessage($(generate_data)) { id idTax idExternal idTelegram messageBody messageExpiredAt phoneNumber status { id active description statusCode statusName smsLogs { id priority } insertedAt } statusId statusChangedAt smsLogs { id priority } insertedAt updatedAt } }" \
     ${URL}
