# Windows Terminal

Good terminal for windows.

## Prereq

Install Chocolatey
Install Git
Install Nerd font
Install jq
Install WSL
Install WSL Ubuntu (latest)

## Install

This script will install 

* Windows Terminal
* JetBrains Nerdfont

```powershell
choco install microsoft-windows-terminal

echo "Install NerdFont: 'JetBrainsMono' Font"
git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add patched-fonts/JetBrainsMono
set-executionpolicy remotesigned
.\install.ps1 JetBrainsMono
```

## Use Nerdfonts in Terminal

If you are using WSL "Ubuntu-20.04" this script will update that terminal to use "JetBrainsMono Nerd Font"

```powershell
 $jsonPath=$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\
 $jsonFile="${jsonPath}settings.json"
 $jsonFileTmp="${jsonPath}temp.json"
 $jsonFileOriginal="${jsonPath}settings-original.json"
 $exist=jq -r '.profiles.list[] | select(.name | test(\"Ubuntu-20.04\"))' "${jsonFile}"
 if (! [string]::IsNullOrWhiteSpace($exist)) {
    echo "Setting Windows Terminal Font to NerdFont: 'JetBrainsMono'"
    jq -r '(.profiles.list[] | select(.name == \"Ubuntu-20.04\") | .font.face)   |=\"JetBrainsMono Nerd Font\"
         | (.profiles.list[] | select(.name == \"Ubuntu-20.04\") | .font.size)   |=14
         | (.profiles.list[] | select(.name == \"Ubuntu-20.04\") | .font.weight) |=\"semi-bold\"' "${jsonFile}" > "$jsonFileTmp"
    mv $jsonFile $jsonFileOriginal
    mv $jsonFileTmp $jsonFile
 }
```