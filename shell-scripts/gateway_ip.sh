#!/bin/bash

get_external_gateway_ip() {
  kubectl get gateway "$1" -o=jsonpath="{.status.addresses[0].value}"
}

while getopts "c:r:p:g:" opt; do
  case "$opt" in
    c) cluster_name="$OPTARG" ;;
    r) region="$OPTARG" ;;
    p) project_id="$OPTARG" ;;
    g) gateway_name="$OPTARG" ;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Connect to the GKE cluster
gcloud container clusters get-credentials "$cluster_name" --region "$region" --project "$project_id"

# Redirect stdout and stderr to separate files
exec > >(tee -a output.txt) 2> >(tee -a error.txt >&2)

external_ip=$(get_external_gateway_ip "$gateway_name")

json_object="{ \"gateway_ip\": \"$external_ip\" }"

# Display the JSON object
echo "$json_object"


