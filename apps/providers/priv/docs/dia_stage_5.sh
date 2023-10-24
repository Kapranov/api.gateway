#!/usr/bin/env bash

# Отримати результат розсилки push-сповіщень
# GET api/v1/notification/distribution/push/{distributionId}
# Статус розсилки (обов’язковий параметр)

# Response {"recipients": [{"rnokpp": "string", "status": "enum ['not-found', 'sent', 'send-error', 'notification-generation-error']"}]}

# Статус розсилки (обов’язковий параметр)
# not-found - не знайдено push-токену. Може виникати, якщо користувач не авторизований в Дії або токен не знайдено з інших причин. Нотифікація не може буде надісланою;
# sent - повідомлення надіслано користувачеві
# send-error - може виникати у випадках, коли не вдалось відправити сповіщення користувачеві через помилку на стороні сервісу надсилання сповіщень
# notification-generation-error - помилка генерації сповіщення. Може виникати у випадках, коли при реєстрації розсилки сповіщень використано набір параметрів, що не відповідає визначеному набору в шаблоні розсилки

# {
#   "name": "Error",
#    "message": "The requested model Distribution bc33e395e549f3113aea66a1c35e5921f836aa325e8c6e7a6b7f85ea59acb57cc8686d0940a10ca377bd9274551d71f008a6710307d58e1ed8c2ffddfe7908cc2f6 could not be found.",
#    "code": 404,
#    "data": {}
# }

curl --location 'https://api2t.diia.gov.ua/api/v1/notification/distribution/push/7a6b41ac371356c4736e5e03d99ddec6bf3216ed09f0dfded1f2c4e74b7eb39fb0d30b8d0c7eeacb040ad1e0667823c94a4273a632bb8481c464b5bdf347a198' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZXlKbGJtTWlPaUpCTVRJNFEwSkRMVWhUTWpVMklpd2lZV3huSWpvaVVsTkJMVTlCUlZBaUxDSnJhV1FpT2lJek0yVTBZamRqTnkweE1EUTRMVFE0WW1ZdFlqY3pOeTB4WkdGaU1EbGpNRE16WTJJaWZRLlplRUJqTlFRdWl1a1hHek9UVkM4TU1zUnoxeGRRZmZGb1RMMVdsZk8xOTUweGZfa3NrNmQ1Q0Y0SWgwTmRqVkNXY3NXQXl6WHhmWE1FM0M1bkxvU0R5d1BfbnJWRUNVRUR4el9XM3NKaFBPU0hQVDIxaVJ3SmJTZTJCRmJJdV9QOXN0OTdHaEpyQjN5b2dXMFc3Y2U3bGRwQ0xlZHJIQnBDZElmLU9KNW55WWo2Z2Jxcl9SSVc5QVlWQzVvR1RBbG1RcWdMSzJSWmpFVWxKQXpRcmpFX3ROUXBqbmxPdGVvV0ZfY3ZQeVkzdFYxZTJORm1uV2xfb0dHWnZrZnk5QmR6OFlVc2hKSmk2VHM0SGhGUTBkc0Q1M3gwYXRQVU42ZjhQTWs1MEs1bmdBcXBIVUw5Xzh6b2ZFYl91NXQ2aGdCV2tsT1BsTDNqN0xYSnZFc3JucDhRdy5OZDliZnA1enVFMlJ2dmVySENsMWJ3LkpkX1RkNGlkTzZsZzRSaFZ5YWFMUE54SHpab0JpRmtPN2FkZVc5OUVucDV6bURvVnpPanhMZXdYSVBzUFJYcUdVY0NWQVZSdVZRR21Jbk9KTi1vaUlIbzVkbUp5ZnpVM3JKY0RfQzZQeThFa084dnF6alBraV9jSTF3YXE3VG9pMzFNX0J6QW5VcW4xQTQxSk05T082TlpwYlB2OTFoaXE0OTlFanR3c1pfcnAtRUVSMTgxRnRaZ3VTekpRbUh6OEptbnNHdHUyTHBZdXFWYjN5VlFNVWZoNC13d0JLUmdfTHd4Z0FvTlFURjhSWEZzSE1XVlpIWk5HU2E5eW51bWoydWhCcW5KYmV5LUlEUmFZc005Y1JETHFJZHM1cTdFdm4xUjI2RlFOalp5VUxMM2ZRVlBreXJuVTRvM2x0TjVOdExNMXdRVi16WnRTTFZ0MUNmREM3eGM5UGhKN1hnT01VQi1xOXpwNTJneWd5a2hkaWpKVndPVk5pSlVkZUlGbC5qbXI0R2JsUE5mR2V4V01aZkhEUFNBIiwiaWF0IjoxNjg0NDE2MzEyLCJleHAiOjE2ODQ0MjM1MTJ9.RYnCRaK6E3BpelV8QJ-8s1hT24yzVY5ZE9BEKP1PuFhlRNUdWQDzIgNamgT-Ck1TKdVrbYa2zBR8nwxLNghXDhvha6odSKjIoypCsobWwzrriWT8wW6CMfNS6Z4Kf1I1LZ1h2EnLHzDurFeYfLc-2g8ZOH_zFOJQmjZ-B9Oag_-Jvdp1AeXVTP2_J-nzn5QHswMsQiyEjbBU2bYmGvJSNR9UEw4v6mJYtJSm9dUX-OIaYViJxMcPB7w8Oev0l2HIs8CQPmSBl7jiJMbp1cODh95R0aCEKMXUMeSbq0S6v5QkYCOD6uYETN1OX7BGXzphzdHT1emiNuRr1waTG7Ujag' \
  --data ''
