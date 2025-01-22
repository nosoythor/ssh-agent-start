# PowerShell Script to Fix and Start ssh-agent Service

# Function to Check and Install OpenSSH if Missing
function Install-OpenSSH {
    Write-Host "Checking OpenSSH installation..." -ForegroundColor Cyan
    $capabilities = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

    foreach ($capability in $capabilities) {
        if ($capability.State -eq "NotPresent") {
            Write-Host "Installing $($capability.Name)..." -ForegroundColor Yellow
            Add-WindowsCapability -Online -Name $capability.Name
        } else {
            Write-Host "$($capability.Name) is already installed." -ForegroundColor Green
        }
    }
}

# Function to Enable and Start ssh-agent Service
function Enable-SSHAgent {
    Write-Host "Configuring ssh-agent service..." -ForegroundColor Cyan

    # Enable the ssh-agent service
    Set-Service -Name ssh-agent -StartupType Automatic -ErrorAction SilentlyContinue

    # Start the ssh-agent service
    try {
        Start-Service ssh-agent
        Write-Host "ssh-agent service started successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to start ssh-agent service. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to Add Firewall Rule for OpenSSH
function Add-FirewallRule {
    Write-Host "Adding firewall rule for OpenSSH..." -ForegroundColor Cyan
    try {
        New-NetFirewallRule -Name "OpenSSH-Server" -DisplayName "OpenSSH Server (sshd)" `
            -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 `
            -ErrorAction SilentlyContinue
        Write-Host "Firewall rule added successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to add firewall rule. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main Script Execution
Write-Host "Starting OpenSSH Configuration Script..." -ForegroundColor Magenta

# Step 1: Install OpenSSH if necessary
Install-OpenSSH

# Step 2: Enable and Start ssh-agent service
Enable-SSHAgent

# Step 3: Add Firewall Rule for OpenSSH
Add-FirewallRule

# Final Message
Write-Host "OpenSSH configuration completed. Please restart your system if needed." -ForegroundColor Cyan

