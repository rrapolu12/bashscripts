#!/bin/bash

parse_yaml() {
    local yaml_file="$1"
    local item_to_parse="$2"
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
    done < "$yaml_file"

    # Return the images array
    if [ "$item_to_parse" == "images" ]; then
        echo "${images[@]}"
    elif [ "$item_to_parse" == "helmcharts" ]; then
        echo "${helmcharts[@]}"
    elif [ "$item_to_parse" == "rpms" ]; then
        echo "${rpms[@]}"
    fi
    
    
}

# Call the function with the YAML file path
#parse_yaml "repo.yaml" "images"
images_array=$(parse_yaml "repo.yaml" "images")

# Print the images array outside the function
echo "=========================================="
echo "Images outside the function:"
for image in "${images_array[@]}"; do
    echo "$image"
done
