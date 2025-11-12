#Requires -Version 5.1

$ErrorActionPreference = "Stop"

$REPO = "vyftlabs/vyft"
$BINARY_NAME = "vyft"
$VERSION = if ($env:VYFT_VERSION) { $env:VYFT_VERSION } else { "latest" }

function Get-LatestVersion {
    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/${REPO}/releases/latest"
    return $response.tag_name
}

function Get-DownloadUrl {
    param(
        [string]$Version,
        [string]$Os,
        [string]$Arch
    )
    
    if ($Version -eq "latest") {
        $Version = Get-LatestVersion
    }
    
    return "https://github.com/${REPO}/releases/download/${Version}/vyft-${Os}-${Arch}.exe"
}

function Get-InstallPath {
    $binPath = Join-Path $env:USERPROFILE ".local\bin"
    
    if (-not (Test-Path $binPath)) {
        New-Item -ItemType Directory -Path $binPath -Force | Out-Null
    }
    
    return Join-Path $binPath "${BINARY_NAME}.exe"
}

function Install-Vyft {
    $os = "windows"
    $arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "x86" }
    
    if ($arch -eq "x86") {
        Write-Error "32-bit Windows is not supported"
        exit 1
    }
    
    Write-Host "Detected platform: ${os}/${arch}"
    
    $downloadUrl = Get-DownloadUrl -Version $VERSION -Os $os -Arch $arch
    $installPath = Get-InstallPath
    
    Write-Host "Downloading ${BINARY_NAME} ${VERSION}..."
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installPath -UseBasicParsing
        Write-Host "Installed ${BINARY_NAME} to ${installPath}"
    }
    catch {
        Write-Error "Failed to download or install: $_"
        exit 1
    }
    
    $pathEnv = [Environment]::GetEnvironmentVariable("Path", "User")
    $binDir = Split-Path $installPath -Parent
    
    if ($pathEnv -notlike "*${binDir}*") {
        Write-Host ""
        Write-Host "Warning: ${binDir} is not in your PATH."
        Write-Host "Add it manually or restart your terminal."
    }
    
    Write-Host ""
    Write-Host "Success! Run '${BINARY_NAME} --version' to verify installation."
}

Install-Vyft

