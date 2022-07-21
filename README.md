Custom powershell modules that I use

To publish and download a local module use:

Publish-Module -Path .\GitCommands\ -Repository LocalPSRepo
Find-Module GitCommands | Install-Module