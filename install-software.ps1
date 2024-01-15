# Install latest .NET 6 SDK and Runtime
Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'

./dotnet-install.ps1 -Version 6.0.100
./dotnet-install.ps1 -Runtime dotnet -Version 6.0.1

Remove-Item -Path 'dotnet-install.ps1'

# Install SQL Server Management Studio (SSMS)
Invoke-WebRequest -Uri 'https://aka.ms/ssmsfullsetup' -OutFile 'SSMS-Setup.exe'
Start-Process -FilePath '.\SSMS-Setup.exe' -ArgumentList '/install /quiet /norestart' -Wait

Remove-Item -Path 'SSMS-Setup.exe'

# Install SqlServer PowerShell module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name SqlServer -AllowClobber -Scope AllUsers -Force

# Install Visual Studio 2022 Community Edition with Azure and Web App packages
Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_community.exe' -OutFile 'vs_community.exe'
Start-Process -FilePath '.\vs_community.exe' -ArgumentList '--quiet', '--norestart', '--wait', '--add Microsoft.VisualStudio.Workload.Azure', '--add Microsoft.VisualStudio.Workload.NetWeb' -Wait

Remove-Item -Path 'vs_community.exe'

# Install .NET Entity Framework Core tools
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
dotnet tool install -g dotnet-ef
dotnet tool install -g microsoft.sqlpackage

# Install Azure CLI
Invoke-WebRequest -Uri 'https://aka.ms/installazurecliwindowsx64' -OutFile 'AzureCLI.msi'
Start-Process -FilePath '.\AzureCLI.msi' -ArgumentList '/quiet' -Wait

Remove-Item -Path 'AzureCLI.msi'

# Install Azure Bicep CLI
az bicep install

# Install Bicep CLI
$BicepVersion = '0.4.1'
$url = "https://github.com/Azure/bicep/releases/download/v${BicepVersion}/bicep-win-x64.exe"
$output = "bicep-win-x64.exe"

Invoke-WebRequest -Uri $url -OutFile $output
New-Item -ItemType Directory -Force -Path "C:\Program Files\bicep"
Move-Item -Path $output -Destination "C:\Program Files\bicep\bicep.exe"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Program Files\bicep', [System.EnvironmentVariableTarget]::Machine)

# Install git bash
$gitPath = Get-Command 'git.exe' -ErrorAction SilentlyContinue
if (-not $gitPath) {
    Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe' -OutFile 'GitInstaller.exe'
    Start-Process -FilePath 'GitInstaller.exe' -ArgumentList '/VERYSILENT' -Wait
    Remove-Item -Path 'GitInstaller.exe'
}

# Restart the VM to ensure all installations take effect
Restart-Computer -Force