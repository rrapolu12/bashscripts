#!/bin/bash

yaml_file="repo.yaml"

# Read YAML file line by line
while IFS= read -r line; do
  # Skip empty lines and comments
  if [[ -z "$line" || "$line" == "#"* ]]; then
    continue
  fi

  # Extract key and value from each line
  key=$(echo "$line" | awk '{split($0, a, ":"); print a[1]}' | sed 's/^[ \t]*//;s/[ \t]*$//')
  value=$(echo "$line" | awk '{split($0, a, ":"); print a[2]}' | sed 's/^[ \t]*//;s/[ \t]*$//')

  # Print key-value pairs
  echo "Key: $key, Value: $value"
done < "$yaml_file"
