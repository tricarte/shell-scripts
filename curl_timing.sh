#!/usr/bin/env bash

# Get both values in a single request
curl_output=$(curl --silent --write-out "total:%{time_total}\nnamelookup:%{time_namelookup}" --output /dev/null "${1}")

# Extract the values
time_total=$(echo "$curl_output" | grep "total:" | cut -d':' -f2)
time_namelookup=$(echo "$curl_output" | grep "namelookup:" | cut -d':' -f2)

# Calculate the difference
time_after_dns=$(echo "$time_total - $time_namelookup" | bc)

echo "Time after DNS lookup :   $time_after_dns seconds"
echo "DNS lookup            :  $time_namelookup seconds"
