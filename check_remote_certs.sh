#!/bin/bash


# This script takes as an argument an IP address of a remote host (to which the user connects through SSH) and a path to a directory 
# where the downloaded certificates are to be stored.
# The script downloads the certificates from the remote host.
# Then, it loops through all the downloaded files and finds those certificates that are going to expire in X amount of time. 
# The matched cases are documented in a unique .txt file which name contains the date and time it was created.
# In that file the user can see the number of found certificates, the subject and enddate of each found certificate.
# Additionally, in the terminal the user is prompted with an information regarding the number of found certificates.


# $1 - IP address of a remote host
# $2 - path to a folder where the downloaded certificates are to be stored
#
# Years to seconds
# 1 - 3155692
# 5 - 157784630
# 10 - 315569260




# Check if a remote host IP address and folder path is provided as an argument
if [ "$#" -ne 2 ]; then
	echo "Error: Please provide a remote host IP address and a folder path as an argument."
	exit 1
fi


remote_host=$1
folder=$2


# Download the certificates from the remote host
mkdir -p $folder/remote_certs
echo | openssl s_client -connect $remote_host:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $folder/remote_certs/remote_cert.pem


# Get the current date and time
current_date_time=$(date +"%Y-%m-%d_%H-%M-%S")

# Create a text file to store the certificate information
touch "expiring_remote_certs_$current_date_time.txt"

# Initialize counter for the number of certificates found
counter=0


# Loop through all files in the remote_certs folder
for file in $folder/remote_certs/*
do
	# Get the expiration date of the certificate
	expiry_date=$(openssl x509 -enddate -noout -in $file | cut -d= -f2)
	
	# Get the current date
	current_date=$(date +%s)
	
	# Convert the expiration date to seconds
	expiry_date_seconds=$(date -d "$expiry_date" +%s)
	
	# Calculate the number of seconds until the certificate expires
	seconds_until_expiry=$((expiry_date_seconds - current_date))
	
	# Check if the certificate will expire within 1 year(s)
	if [ $seconds_until_expiry -lt 31536000 ]; then
		# Get the subject of the certificate
		subject=$(openssl x509 -subject -noout -in $file)
		
		# Write the subject and expiration date to the text file
		echo "$subject expires on $expiry_date" >> "expiring_remote_certs_$current_date_time.txt"
		
		# Increment the counter
		((counter++))
	fi
done


# Write the number of certificates found to the top of the text file
echo "Number of certificates found: $counter" | cat - "expiring_remote_certs_$current_date_time.txt" > temp && mv temp "expiring_remote_certs_$current_date_time.txt"

# Print a message in the terminal
echo $'\n'Found  $counter certificates that are due to expire.$'\n'Please open "expiring_remote_certs_$current_date_time.txt" file for more detail.$'\n'
	
	
	
	
	
	
	
	
	
