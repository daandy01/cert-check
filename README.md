
Tool for finding local and remote certificates that are going to expire in X amount of time.

This repository contains two .sh files (bash scripts):
1) check_local_certs.sh

This script takes as an argument a path to a directory with local certificates. Then, it loops through all the files in that directory and finds those certificates
that are going to expire in X amount of time. The matched cases are documented in a unique .txt file which name contains the date and time it was created.
In that file the user can see the number of found certificates, the subject and enddate of each found certificate. 
Additionally, in the terminal the user is prompted with an information regarding the number of found certificates.

2) check_remote_certs.sh

This script takes as an argument an IP address of a remote host (to which the user connects through SSH) and a path to a directory where the downloaded certificates are to be stored.
The script downloads the certificates from the remote host.
Then, it loops through all the downloaded files and finds those certificates that are going to expire in X amount of time. 
The matched cases are documented in a unique .txt file which name contains the date and time it was created.
In that file the user can see the number of found certificates, the subject and enddate of each found certificate.
Additionally, in the terminal the user is prompted with an information regarding the number of found certificates.
