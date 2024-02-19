#!/bin/bash

# Replace 'your-project-id' with your actual GCP project ID
PROJECT_ID="prj-polygonlabs-zkevm-dev"
# Use gcloud to list HTTPS target proxies in the GCP project and store the names in an array
HTTPS_TARGET_PROXIES=($(gcloud compute target-https-proxies list --project "$PROJECT_ID" --format="value(NAME)"))

# Iterate through the list of HTTPS target proxies and update each one
for PROXY_NAME in "${HTTPS_TARGET_PROXIES[@]}"; do
  # Replace 'zkevm-certificate-map' with the name of the certificate map to use
  CERTIFICATE_MAP="zkevm-sandbox1-certificate-map"
  
  # Update the HTTPS target proxy with the certificate map
  gcloud compute target-https-proxies update "$PROXY_NAME" --certificate-map="$CERTIFICATE_MAP" --project "$PROJECT_ID"

  # Check if the update was successful
  if [ $? -eq 0 ]; then
    echo "Updated HTTPS Target Proxy '$PROXY_NAME' with certificate map '$CERTIFICATE_MAP'"
  else
    echo "Failed to update HTTPS Target Proxy '$PROXY_NAME'"
  fi
done


