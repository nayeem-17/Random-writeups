
# 🔧 Technical Deep Dive: Configuring GitHub Actions Self-Hosted Runner on Azure Windows VM

After a 14-hour debugging marathon, I successfully configured a GitHub Actions self-hosted runner on Azure. Here's my comprehensive troubleshooting journey that might save someone else valuable time.

**Environment Details**:

- VM: Azure Standard_B2ms (Windows)
- Configuration: VM with managed identity
- Goal: Run Windows container-based CI pipeline

**Pipeline Requirements**:

-  Code checkout from repository
-  Azure Container Registry (ACR) authentication
-  Docker image building with custom tags
-  Push built images to ACR

### 🔍 Challenge #1: Code Checkout Failure

`Problem`: The checkout action consistently failed during the unzip operation
Root Cause: Windows default path length limitation

`Solution`: 
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
-Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```
`Reference`: 

Found the solution in a Stack Overflow thread:\
 https://stackoverflow.com/questions/66319919/github-action-checkout-fails-when-unzipping-with-self-hosted-agent

### 🔍 Challenge #2: Azure CLI Availability
`Problem`: Actions runner couldn't find 'az' command\
`Investigation`:
  - Initially installed Azure CLI using Scoop during bootstrap
  - Actions runner user ≠ Admin user who ran bootstrap
  - Scoop installations are user-level only
  
  `Solution`: 
- Switched to Chocolatey for system-wide installation
- Added during VM bootstrap: 
```powershell
choco install azure-cli -y
```

### 🔍 Challenge #3: Docker Installation Complexities

`Problem`: Multiple Docker installation options leading to confusion

`Investigation`:
- Tested various Docker installation combinations
- Many unnecessary components for our use case

`Solution`:
- Minimal required packages identified:
```powershell
choco install docker-cli -y
choco install docker-engine -y
```
These packages were sufficient for building and running Windows containers.

### 🔍 Challenge #4: Azure Authentication

`Problem`: Azure CLI authenticated in SSH session but failed in Actions

`Investigation`:
- Managed identity worked in interactive sessions
- Actions runner context required explicit authentication

`Solution`:
```yaml
- run: |
    az login --identity --username ${{ secrets.MANAGED_IDENTITY_CLIENT_ID }}
```

### 🔍 Challenge #5: Git Security Warning

`Problem`: Git detected security risk due to repository owner/user mismatch

`Solution`:
```bash
git config --global --add safe.directory *
```
This configured the repository as a safe directory globally.


### 💡 Key Learnings:
-  System-wide vs user-level package management is crucial for automation
-  Windows containers require specific Docker component combinations
-  Managed identities need explicit handling in non-interactive contexts
- Windows path limitations can affect Git operations
- Security contexts differ between interactive and automated sessions
