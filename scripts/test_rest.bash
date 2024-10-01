#!/bin/bash

clear && echo

read -s -p "Enter your AI SIEM KEY: " SDL_API_TOKEN
export SDL_API_TOKEN

echo && echo


# The REGION to the SDL intake API. Region choices are: us1, au1, euw31, ca1, ap1, aps1, and aps2.
# US: https://ingest.us1.sentinelone.net/services/collector/raw
# EU: https://ingest.euw31.sentinelone.net/services/collector/raw
# Ca: https://ingest.ca1.sentinelone.net/services/collector/raw
# AP: https://ingest.ap1.sentinelone.net/services/collector/raw
# AP: https://ingest.aps1.sentinelone.net/services/collector/raw
# AP: https://ingest.aps2.sentinelone.net/services/collector/raw

REGION="us1"

# The default value is paloaltonetworksfirewall. The other options are: fortinetfortimanager, 
# zscalerinternetaccess, ciscofirewallthreatdefense, and fortinetfortigate
SOURCE="paloaltonetworksfirewall"

# The SOURCETYPE to the SDL intake API. 
SOURCETYPE="marketplace-${SOURCE}-latest"

SDL_URL="https://ingest.${REGION}.sentinelone.net/services/collector/raw?sourcetype=${SOURCETYPE}"

message="$(date '+%b %d %H:%M:%S %Z') $(hostname) tester[$$]: Test message to SDL intake API using curl and ${SOURCE}"
echo $message && echo && echo

# Check if the environment variable SDL_API_TOKEN exists and is not empty
if [ -n "$SDL_API_TOKEN" ]; then

    curl -v -k "${SDL_URL}" \
    -H "Authorization: Bearer ${SDL_API_TOKEN}" \
    -H "Accept: application/text" \
    -d "${message}"
    
fi
