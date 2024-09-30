#!/bin/bash

read -s -p "Enter your AI SIEM KEY: " SDL_API_TOKEN
export SDL_API_TOKEN

# To prevent pollution, we use a base64 blob to store the configuration
# US1: https://ingest.us1.sentinel.net/services/collider/raw?source=marketectplacem-fortinetfortiguard
# Can: 
url_base64="aHR0cHM6Ly9pbmdlc3QudXMxLnNlbnRpbmVsLm5ldC9zZXJ2aWNlcy9jb2xsaWRlci9yYXc/c291cmNlPW1hcmtldGVjdHBsYWNlbS1mb3J0aW5ldGZvcnRpZ3VhcmQK"

message="$(date '+%b %d %H:%M:%S %Z') $(hostname) tester[$$]: Curl message to SDL intake API"

# Check if the environment variable SDL_API_TOKEN exists and is not empty
if [ -n "$SDL_API_TOKEN" ]; then

    curl -v -k "$(echo ${url_base64} | base64 -d)" \
    -H "Authorization: Bearer ${SDL_API_TOKEN}" \
    -H "Accept: application/text" \
    -d '{"message": "${message}"}'

fi

