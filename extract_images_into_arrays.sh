#!/bin/bash

# Define arrays to store lines under different sections
declare -a images
declare -a helmcharts
declare -a rpms

# Set the flag to false initially
in_images=false
in_helmcharts=false
in_rpms=false

# Read the YAML file line by line
while IFS= read -r line; do
    # Check if the line contains the start of the 'images' section
    if [[ "$line" =~ ^images: ]]; then
        in_images=true
        in_helmcharts=false
        in_rpms=false
    # Check if the line contains the start of the 'helmcharts' section
    elif [[ "$line" =~ ^helmcharts: ]]; then
        in_images=false
        in_helmcharts=true
        in_rpms=false
    # Check if the line contains the start of the 'rpms' section
    elif [[ "$line" =~ ^rpms: ]]; then
        in_images=false
        in_helmcharts=false
        in_rpms=true
    # Check if the line is not empty and is not a comment
    elif [[ -n "$line" && ! "$line" =~ ^\s*# ]]; then
        # Depending on the current section, append the line to the corresponding array
        if [ "$in_images" = true ]; then
            images+=("$line")
        elif [ "$in_helmcharts" = true ]; then
            helmcharts+=("$line")
        elif [ "$in_rpms" = true ]; then
            rpms+=("$line")
        fi
    fi
done < repo.yaml

# Print the contents of the arrays (optional)
echo "Images:"
for image in "${images[@]}"; do
    echo "  $image"
done

echo "Helmcharts:"
for helmchart in "${helmcharts[@]}"; do
    echo "  $helmchart"
done

echo "RPMs:"
for rpm in "${rpms[@]}"; do
    echo "  $rpm"
done
