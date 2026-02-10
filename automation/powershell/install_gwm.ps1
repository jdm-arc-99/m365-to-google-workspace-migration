param (
    [Parameter(Mandatory = $true)]
    [string]$installerUrl,

    [Parameter(Mandatory = $false)]
    [string]$adminUsername = "migration-admin",

    [Parameter(Mandatory = $false)]
    [string]$component = "platform" # platform, node, mysql, couchdb
)

$ErrorActionPreference = "Stop"
$tempDir = "C:\Temp"
$installerPath = "$tempDir\installer.msi"

Write-Output "Starting GWM Installation for component: $component"

# Create Temp directory
if (-Not (Test-Path $tempDir)) {
    New-Item $tempDir -ItemType Directory | Out-Null
}

# Download installer
Write-Output "Downloading installer from $installerUrl"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Component-specific logic
switch ($component) {
    "platform" {
        Write-Output "Installing Google Workspace Migrate Platform..."
        Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait
    }
    "node" {
        Write-Output "Installing Google Workspace Migrate Node..."
        Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait
    }
    "mysql" {
        Write-Output "Installing MySQL Server..."
        # MySQL silent install parameters would go here
        Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn" -Wait
    }
    "couchdb" {
        Write-Output "Installing CouchDB..."
        Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn" -Wait
    }
}

Write-Output "Installation complete."
