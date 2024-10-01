#!/bin/bash

# This script is designed to send a test message to the SentinelOne Data Lake (SDL) intake API.
# It prompts the user to enter their AI SIEM key, sets the necessary environment variables, 
# and constructs the appropriate API endpoint URL based on the specified region and source type.
# The script then sends a test message using the curl command to verify the connection and 
# configuration. The message includes a timestamp, hostname, and process ID for identification.

clear && echo

read -s -p "Enter your AI SIEM KEY: " SDL_API_TOKEN
export SDL_API_TOKEN

# The REGION to the SDL intake API. The default value is us1. The other options are:
# US1: United States
# EU1: Europe (AWS)
# EUW31: Europe (GCP)
# CA1: Canada
# AP1: Asia Pacific (Singapore)
# APS1: Asia Pacific (Mumbai)
# APS2: Asia Pacific (Sydney)

REGION="us1"

# The default source is paloaltonetworksfirewall. The other options are: fortinetfortimanager, 
# zscalerinternetaccess, ciscofirewallthreatdefense, and fortinetfortigate. Alternatively, you
# can replace the SOURCETYPE variable with syslog.
SOURCE="paloaltonetworksfirewall"

# The SOURCETYPE to the SDL intake API. 
SOURCETYPE="marketplace-${SOURCE}-latest"

SDL_URL="https://ingest.${REGION}.sentinelone.net/services/collector/raw?sourcetype=${SOURCETYPE}"

echo && echo
message="$(date '+%b %d %H:%M:%S %Z') $(hostname) tester[$$]: Test message to SDL intake API using curl and ${SOURCE}"
echo $message && echo && echo

# Check if the environment variable SDL_API_TOKEN exists and is not empty
if [ -n "$SDL_API_TOKEN" ]; then

    curl -v -k "${SDL_URL}" \
    -H "Authorization: Bearer ${SDL_API_TOKEN}" \
    -H "Accept: application/text" \
    -d "${message}"

fi
