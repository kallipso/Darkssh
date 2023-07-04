#!/bin/bash

# Set the maximum allowed concurrent connections
MAX_CONNECTIONS=1

# Get the currently logged-in user from PAM_USER environment variable
CURRENT_USER="$PAM_USER"

# Check if the current user is root
if [ "$CURRENT_USER" = "root" ]; then
  # Allow root user to have unlimited concurrent connections
  exit 0
fi

# Check if the current user is online using lsof and netstat
LIVE_CONNECTIONS=$(sudo lsof -u "$CURRENT_USER" | grep "ESTABLISHED" | wc -l)
LIVE_CONNECTIONS_NETSTAT=$(sudo netstat -anp | grep ":443.*ESTABLISHED.*$CURRENT_USER" | wc -l)

# Calculate the total live connections by summing the results from lsof and netstat
TOTAL_LIVE_CONNECTIONS=$((LIVE_CONNECTIONS + LIVE_CONNECTIONS_NETSTAT))

# Compare the number of live connections with the maximum allowed connections
if [ "$TOTAL_LIVE_CONNECTIONS" -ge "$MAX_CONNECTIONS" ]; then
  # Deny access if the number of live connections exceeds the maximum allowed
  echo "تعداد اتصال ها بیش از حد. لطفا از یک دستگاه استفاده کنید."
  exit 1
else
  # Allow access if the number of live connections is within the allowed limit
  exit 0
fi
