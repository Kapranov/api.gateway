#!/usr/bin/env bash

# Авторизація

curl --location 'https://api2t.diia.gov.ua/api/v2/auth/partner' \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --data '{"bearerToken": "WZTB25QSB25dHxBxCaH86Xe6Jd3dP4LhInrWZKS2ew5Yt4w2SCxMyvPAG8X3ffI8"}'
