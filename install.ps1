#Requires -Version 5.1

$ErrorActionPreference = "Stop"

$REPO = "bytekai/vyft.go"
$BINARY_NAME = "vyft"
$VERSION = if ($env:VYFT_VERSION) { $env:VYFT_VERSION } else { "latest" }

function Get-LatestVersion {
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/${REPO}/releases/latest" -ErrorAction Stop
        return $response.tag_name
    }
    catch {
        Write-Error "Could not fetch latest version from GitHub."
        Write-Host "This may mean:" -ForegroundColor Yellow
        Write-Host "  1. The repository doesn't exist yet or isn't public"
        Write-Host "  2. No releases have been published yet"
        Write-Host "  3. You're offline or GitHub is unreachable"
        Write-Host ""
        Write-Host "Please install from source instead:"
        Write-Host "  git clone https://github.com/${REPO}"
        Write-Host "  cd vyft.go && go build -o vyft"
        exit 1
    }
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
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installPath -UseBasicParsing -ErrorAction Stop
        Write-Host "Installed ${BINARY_NAME} to ${installPath}"
    }
    catch {
        Write-Error "Failed to download or install ${BINARY_NAME}"
        Write-Host "URL: $downloadUrl" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "This may mean:" -ForegroundColor Yellow
        Write-Host "  1. The release ${VERSION} doesn't exist"
        Write-Host "  2. The binary for ${os}/${arch} isn't available"
        Write-Host "  3. You're offline or GitHub is unreachable"
        Write-Host ""
        Write-Host "Please install from source instead:"
        Write-Host "  git clone https://github.com/${REPO}"
        Write-Host "  cd vyft.go && go build -o vyft"
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

