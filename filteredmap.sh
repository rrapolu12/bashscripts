#!/bin/bash

yaml_file="repo.yaml"
in_images=false
in_helmcharts=false
in_rpms=false

declare -A images_dict
declare -A helmcharts_dict
declare -A rpms_dict

# Read YAML file line by line
while IFS= read -r line; do
  # Skip empty lines and comments
  if [[ -z "$line" || "$line" == "#"* ]]; then
    continue
  fi

  # Check if we are inside the "images" section
  if [[ "$line" == "images:" ]]; then
    in_images=true
    in_helmcharts=false
    in_rpms=false
    continue
  fi

  # Check if we are inside the "helmcharts" section
  if [[ "$line" == "helmcharts:" ]]; then
    in_images=false
    in_helmcharts=true
    in_rpms=false
    continue
  fi

  # Check if we are inside the "rpms" section
  if [[ "$line" == "rpms:" ]]; then
    in_images=false
    in_helmcharts=false
    in_rpms=true
    continue
  fi

  # Extract key and value from each line if inside "images," "helmcharts," or "rpms"
  if [[ "$in_images" == true ]]; then
    key=$(echo "$line" | sed -E 's/^[ \t]*- (.+):[0-9]+\.[0-9]+\.[0-9]+/\1/' | sed 's/^[ \t]*//;s/[ \t]*$//')
    value=$(echo "$line" | awk '{split($0, a, ":"); print a[2]}' | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Add key-value pairs to images_dict
    images_dict["$key"]=$value
  elif [[ "$in_helmcharts" == true ]]; then
    key=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')
    
    # Add key to helmcharts_dict
    helmcharts_dict["$key"]=1  # Value is set to 1, as no specific value is provided in the YAML
  elif [[ "$in_rpms" == true ]]; then
    key=$(echo "$line" | sed -E 's/^[ \t]*- (.+):[0-9]+\.[0-9]+\.[0-9]+/\1/' | sed 's/^[ \t]*//;s/[ \t]*$//')
    value=$(echo "$line" | awk '{split($0, a, ":"); print a[2]}' | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Add key-value pairs to rpms_dict
    rpms_dict["$key"]=$value
  fi

done < "$yaml_file"

# Print dictionaries
echo "Images Dictionary:"
declare -p images_dict

echo -e "\nHelmcharts Dictionary:"
declare -p helmcharts_dict

echo -e "\nRPMs Dictionary:"
declare -p rpms_dict
