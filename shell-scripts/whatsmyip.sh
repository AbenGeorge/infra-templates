#!/bin/bash

# Get the public IP address using curl and ifconfig.me
public_ip=$(curl -s -4 ifconfig.me)

# Replace the last number with 0
modified_ip="${public_ip%.*}.0"
json_object="{ \"internet_ip\": \"$modified_ip\" }"

# Display the JSON object
echo "$json_object"


