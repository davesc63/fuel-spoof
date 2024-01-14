#!/bin/bash

# check for prerequisites
# Check and delete "fuel-spoof.txt" if it exists
if [ -e "fuel-spoof.txt" ]; then
    rm "fuel-spoof.txt"
fi

# Check if python3 is installed
if sudo command -v python3 &> /dev/null; then
    #echo "Python3 is installed"
    # Store the Python path using sudo
    python_path=$(sudo which python3)
    #echo "Python path: $python_path"
else
    echo "python3 not found"
    echo "Please install Python"
    exit 1
fi

# Check if pymobiledevice3 is installed
# Check if the module is installed
if sudo $python_path -m pip show pymobiledevice3 &>/dev/null; then
    #echo "pymobiledevice3 is installed"
    echo -e "\n"
else
    echo "pymobiledevice3 not found"
    echo "Please install using 'sudo python3 -m pip install pymobiledevice3'"
    exit 1
fi
# Check if jq is installed
if command -v jq &>/dev/null; then
    #echo "pymobiledevice3 is installed"
    echo -e "\n"
else
    echo "jq not found"
    echo "Please install jq"
    exit 1
fi


# Function to make API request and extract data based on user choice
get_api_data() {
    local choice=$1
    local api_url="https://projectzerothree.info/api.php?format=json"
    local response=$(curl -sS --location $api_url)
    
    # Extract data based on user choice
    local selected_data=$(echo "$response" | jq -r '.regions[] | select(.region == "All").prices[] | select(.type == "'"$choice"'")')
    
    # Extract relevant information
    local type=$(echo $selected_data | jq -r '.type')
    local price=$(echo $selected_data | jq -r '.price')
    local suburb=$(echo $selected_data | jq -r '.suburb')
    local state=$(echo $selected_data | jq -r '.state')
    local lat=$(echo $selected_data | jq -r '.lat')
    local lng=$(echo $selected_data | jq -r '.lng')
    
    # Print selected data
    echo -e "\nYou selected: $choice\n"
    echo -e "The cheapest $choice is at $suburb in $state\n"
    echo -e "\nType: $type\nPrice: $price\nlat: $lat\nlng: $lng"
    echo -e "\n"
    
    # Set the location variable
    location="$lat $lng"
}

# Present user with options
echo -e "\n======== Welcome to iOS17 fuel spoofing ========="
echo -e "Fuel data sourced from projectzerothree.info"
echo -e "Requires pymobiledevice3 / python"
echo -e "Please consider buying me a coffee - Thank you!"
echo -e "=================================================\n"
echo -e "\nSelect a fuel type:"
echo "1) E10"
echo "2) U91"
echo "3) U95"
echo "4) U98"
echo "5) Diesel"
echo "6) LPG"
echo "e) Exit"
echo -e "\n"
read -p "Enter your choice (1, 2, 3, 4, 5, 6 or e): " user_choice

case $user_choice in
    1)
        get_api_data "E10"
        ;;
    2)
        get_api_data "U91"
        ;;
    3)
        get_api_data "U95"
        ;;
    4)
        get_api_data "U98"
        ;;
    5)
        get_api_data "Diesel"
        ;;
    6)
        get_api_data "LPG"
        ;;
    e)  echo "Exiting script..."
        exit 1
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Execute Step 1 and save the output to a file
echo -e "Starting the tunnel - please wait..."
sudo $python_path -m pymobiledevice3 remote start-tunnel --script-mode > fuel-spoof.txt &
# Give Step 1 some time to start before proceeding
#sleep 20

# Wait until fuek-spoof.txt has some text
while [[ ! -s fuel-spoof.txt ]]; do
    sleep 1
done


# Combine RSD Address and RSD Port
rsd_data=$(head -n 1 fuel-spoof.txt)

echo -e "\nDevice RSD data is: $rsd_data"


# Step 2 - Mount developer image
echo -e "\nMounting the developer image\n"
sudo $python_path -m pymobiledevice3 mounter auto-mount

# Step 4 - spoof location
echo -e "\nLocation Simulation is now running\n"
echo -e "Spoofing location to ($location)"
echo -e "You can now open your app and your location will be simulated"
echo -e "You will need to press CTRL-C to continue the script once you've completed your location activities"

# full_command="sudo $python_path -m pymobiledevice3 developer dvt simulate-location set --rsd $rsd_data -- $location"
# echo $full_command
# $full_command
#echo -e "\nExecuting: $full_command\n"
sudo $python_path -m pymobiledevice3 developer dvt simulate-location set --rsd $rsd_data -- $location

# Step 5 - Clear the simulated location
echo -e "\n"
read -p "Press Enter to clear the simulated location..."
sudo $python_path -m pymobiledevice3 developer dvt simulate-location clear --rsd $rsd_data

# Cleanup: remove the temporary file
echo -e "\nCleaning up temp file"
rm -f fuel-spoof.txt
echo -e "\nScript complete - Hope you enjoyed!"