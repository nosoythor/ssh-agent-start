## How to Run the Script

Open PowerShell as Administrator.

Save the script to a file, for example, Configure-OpenSSH.ps1.

Run the script:

.\Configure-OpenSSH.ps1

## What This Script Does

Checks if OpenSSH Client and Server are installed, and installs them if they’re missing.

Sets the ssh-agent service to start automatically and attempts to start it.

Adds a firewall rule to allow incoming SSH connections on port 22.

Provides feedback on each step.
