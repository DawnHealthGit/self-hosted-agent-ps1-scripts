# Install latest .NET 6 SDK and Runtime
Invoke-WebRequest -Uri 'https://dotnet.microsoft.com/download/dotnet/thank-you/sdk-6.0.100-windows-x64-installer' -OutFile 'dotnet-sdk-installer.exe'
Start-Process -FilePath '.\dotnet-sdk-installer.exe' -ArgumentList '/install /quiet /norestart' -Wait

Invoke-WebRequest -Uri 'https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-6.0.1-windows-x64-installer' -OutFile 'dotnet-runtime-installer.exe'
Start-Process -FilePath '.\dotnet-runtime-installer.exe' -ArgumentList '/install /quiet /norestart' -Wait

# Install SQL Server Management Studio (SSMS)
Invoke-WebRequest -Uri 'https://aka.ms/ssmsfullsetup' -OutFile 'SSMS-Setup.exe'
Start-Process -FilePath '.\SSMS-Setup.exe' -ArgumentList '/install /quiet /norestart' -Wait

# Install SqlServer PowerShell module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name SqlServer -AllowClobber -Scope AllUsers -Force

# Install SQLPackage
dotnet tool install -g Microsoft.Data.Tools.Msbuild

# Install Visual Studio 2022 Community Edition with Azure and Web App packages
Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_community.exe' -OutFile 'vs_community.exe'
Start-Process -FilePath '.\vs_community.exe' -ArgumentList '--quiet', '--norestart', '--wait', '--add Microsoft.VisualStudio.Workload.Azure', '--add Microsoft.VisualStudio.Workload.NetWeb' -Wait

# Install .NET Entity Framework Core tools
dotnet tool install --global dotnet-ef
dotnet tool install -g microsoft.sqlpackage

# Install Azure CLI
Invoke-WebRequest -Uri 'https://aka.ms/installazurecliwindows' -OutFile 'AzureCLI.msi'
Start-Process -FilePath '.\AzureCLI.msi' -ArgumentList '/quiet' -Wait

# Install Azure Bicep CLI
$BicepVersion = (Invoke-RestMethod -Uri 'https://api.github.com/repos/Azure/bicep/releases/latest').tag_name
$url = "https://github.com/Azure/bicep/releases/download/${BicepVersion}/bicep-win-x64.exe"
$output = "bicep-win-x64.exe"

# Install Bicep CLI
$BicepVersion = '0.4.1'
$url = "https://github.com/Azure/bicep/releases/download/v${BicepVersion}/bicep-win-x64.exe"
$output = "bicep-win-x64.exe"

Invoke-WebRequest -Uri $url -OutFile $output
New-Item -ItemType Directory -Force -Path "C:\Program Files\bicep"
Move-Item -Path $output -Destination "C:\Program Files\bicep\bicep.exe"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Program Files\bicep', [System.EnvironmentVariableTarget]::Machine)

# Restart the VM to ensure all installations take effect
Restart-Computer -Force
