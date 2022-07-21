# Use this script to get a list of directories to include in npm audit tasks for each azure pipeline
$filePath = "./package-locations-log.txt"

if ( Test-Path $filePath) {
    Clear-Content -Path $filePath
} else {
    New-Item -Path $filePath
}

Get-ChildItem -Path "C:\Projects\Enable" -Recurse -Filter package.json -ErrorAction SilentlyContinue `
| Where-Object { $_.DirectoryName -NotMatch "node_modules" } `
| Where-Object { $_.DirectoryName -NotMatch "bin" } `
| Where-Object {(Get-ChildItem -Path $_.DirectoryName -Filter package-lock.json).Length -ne 0} `
| Select-Object -ExpandProperty DirectoryName -Unique `
| ForEach-Object { `
	$content = "package.json file found at location: $_"
    Add-Content -Path $filePath -Value $content

	Push-Location $_;`

    $hasGitChanges = Get-HasGitChanges

    if ( $hasGitChanges ) {
        Write-Host "Git changes in $_"
    }

    # git checkout main

    # git pull

    # git checkout -b feature/fn/node-16-upgrades

    # npm i

    # git commit * -m "Update packages for Node 16 upgrade"

    # GitPushCurrentBranch

	Pop-Location;`
}