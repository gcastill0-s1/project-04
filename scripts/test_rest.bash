#!/bin/bash

read -s -p "Enter your AI SIEM KEY: " SDL_API_TOKEN
export SDL_API_TOKEN

# To prevent pollution, we use a base64 blob to store the configuration
# Ca: https://ingest.ca1.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
# url_base64="aHR0cHM6Ly9pbmdlc3QuY2ExLnNlbnRpbmVsb25lLm5ldC9zZXJ2aWNlcy9jb2xsZWN0b3IvcmF3P3NvdXJjZXR5cGU9bWFya2V0cGxhY2UtcGFsb2FsdG9uZXR3b3Jrc2ZpcmV3YWxsLWxhdGVzdAo="

# US: https://ingest.us1.sentinelone.net/services/collector/raw?sourcetype=marketplace-paloaltonetworksfirewall-latest
url_base64="aHR0cHM6Ly9pbmdlc3QudXMxLnNlbnRpbmVsb25lLm5ldC9zZXJ2aWNlcy9jb2xsZWN0b3IvcmF3P3NvdXJjZXR5cGU9bWFya2V0cGxhY2UtcGFsb2FsdG9uZXR3b3Jrc2ZpcmV3YWxsLWxhdGVzdAo="

message="$(date '+%b %d %H:%M:%S %Z') $(hostname) tester[$$]: Curl message to SDL intake API"

# Check if the environment variable SDL_API_TOKEN exists and is not empty
if [ -n "$SDL_API_TOKEN" ]; then

    curl -v -k "$(echo ${url_base64} | base64 -d)" \
    -H "Authorization: Bearer ${SDL_API_TOKEN}" \
    -H "Accept: application/text" \
    -d "${message}"
fi

