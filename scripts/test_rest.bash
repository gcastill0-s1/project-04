#!/bin/bash

read -s -p "Enter your AI SIEM KEY: " SDL_API_TOKEN
export SDL_API_TOKEN

# US: https://ingest.us1.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
# EU: https://ingest.euw31.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
# Ca: https://ingest.ca1.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
# AP: https://ingest.ap1.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
# AP: https://ingest.aps1.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
# AP: https://ingest.aps2.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest

# The URL to the SDL intake API. Region choices are: us1, au1, euw31, ca1, ap1, aps1, and aps2.
REGION="us1"
SOURCETYPE="marketplace-paloaltonetworksfirewall-latest"
SDL_URL="https://ingest.${REGION}.sentinelone.net/services/collector/raw?sourcetype=${SOURCETYPE}"

message="$(date '+%b %d %H:%M:%S %Z') $(hostname) tester[$$]: Curl message to SDL intake API"
echo $message

# Check if the environment variable SDL_API_TOKEN exists and is not empty
if [ -n "$SDL_API_TOKEN" ]; then

    curl -v -k "${SDL_URL}" \
    -H "Authorization: Bearer ${SDL_API_TOKEN}" \
    -H "Accept: application/text" \
    -d "${message}"
fi
