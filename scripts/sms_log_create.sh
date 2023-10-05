#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAAEBvdUk2YTJBV3Y2QnFMWVd6NTdXM3luVnpxVnVjMG5pTHBpbXJFU0dVNlM3bFVjcGMySHFaWUk2bHhaZWtiZ3Y4bgYAsEpk8IoBYgABUYA.zcP0xJ8t_jrZydwXqxrMo1v6bRSymkNL0E4rYG8Ob74"
URL="http://taxgig.me:4000"

generate_data() {
cat << EOF
priority: 8
messageId: "AaS3U9cnAUmXJC4FgO"
operatorId: "AaS3TYdufMh4bxJ7nG"
statusId: "AaS3TqkxJv1Sn0k0Gm"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="mutation { createSmsLog($(generate_data)) { id priority insertedAt statuses { id active description statusCode statusName insertedAt smsLogs { id } } messages { id idExternal idTax idTelegram messageBody messageExpiredAt phoneNumber status { id active description smsLogs { id } statusCode statusName insertedAt } statusChangedAt statusId insertedAt updatedAt } operators { id active config { id name size url insertedAt updatedAt parameters { id key value insertedAt updatedAt } } limitCount nameOperator operatorType { id active nameType priority insertedAt updatedAt } phoneCode priceExt priceInt priority insertedAt updatedAt sms_logs { id } } } }" \
     ${URL}
