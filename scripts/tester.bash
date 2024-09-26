#!/bin/bash

# Set initial message number
counter=1

# Simulate a thread number
thread=$((RANDOM % 1024 + 1))

# Define the destination (localhost in this case, change as needed)
destination="localhost"
port="514"

# Loop to send 50 messages
while [ $counter -le 50 ]; do
  # Create the message with an incremental counter
  message="$(date '+%b %d %H:%M:%S %Z') $(hostname) tester[$$]: Message number ${counter} to UDP port ${port} thread ${thread}"

  # Send the message via netcat using UDP to port 514
  echo "$message" | nc -u -w1 $destination $port

  # Increment the counter
  ((counter++))

  # Generate a random delay between 1 and 3 seconds
  delay=$((RANDOM % 5 + 1))

  # Display the test message
  printf '%s\t' "$message"

  while [ $delay -gt 0 ]; do
    echo -n "."
    sleep 1
    ((delay--))
  done

  echo ""

done