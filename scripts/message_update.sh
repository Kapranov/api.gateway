#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAAEBvdUk2YTJBV3Y2QnFMWVd6NTdXM3luVnpxVnVjMG5pTHBpbXJFU0dVNlM3bFVjcGMySHFaWUk2bHhaZWtiZ3Y4bgYAsEpk8IoBYgABUYA.zcP0xJ8t_jrZydwXqxrMo1v6bRSymkNL0E4rYG8Ob74"
URL="http://taxgig.me:4000"

generate_data() {
cat << EOF
id: "AaQUeik0x534HMdEY4"
message: {
idExternal: "3"
idTax: 1999555222
idTelegram: "@telegaUser"
messageBody: "Ваш код - 7777-222-2222-2222"
messageExpiredAt: "2023-10-01 11:32:32.477759Z"
phoneNumber: "+380997173333"
statusChangedAt: "2023-10-04 11:22:11.477759Z"
statusId: "AaQPUdnGtcTcmCNus4"
}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="mutation { updateMessage($(generate_data)) { id idTax idExternal idTelegram messageBody messageExpiredAt phoneNumber status { id active description statusCode statusName smsLogs { id priority } insertedAt } statusId statusChangedAt smsLogs { id priority } insertedAt updatedAt } }" \
     ${URL}

