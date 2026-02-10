# Common PowerShell Utilities for GCE

function Set-PowerPlan {
    Write-Host "Setting power plan to High Performance..."
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
}

function Enable-RemoteDesktop {
    Write-Host "Enabling RDP and opening firewall..."
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
}

function Install-Net48 {
    Write-Host "Checking for .NET Framework 4.8..."
    # Add logic here
}
