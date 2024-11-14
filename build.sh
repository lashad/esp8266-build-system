#!/bin/bash

# Run the docker command, print output to terminal, and capture both stdout and stderr
echo "Building project..."
output=$(docker run --rm -v "$PWD":/root/esp/build -w /root/esp/build my-esp8266-build make all 2>&1)

# Check if the docker run command was successful
if [ $? -eq 0 ]; then

    # If successful, parse and extract the flashing command
    result=$(echo "$output" | sed -n 's|^.*python /root/esp/ESP8266_RTOS_SDK/components/esptool_py/esptool/esptool.py ||p' | sed 's|/root/esp/build|.|g')
    
    # Output the result
    esptool.py $result
else
    # If docker run failed, print the error message
    echo "Docker run failed. Here is the error:"
    echo "$output"
    exit 1  # Exit with a non-zero status to indicate failure
fi


