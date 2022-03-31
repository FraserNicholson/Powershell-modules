function Rename-FilesInFolder {
    param (
        [Parameter(Mandatory)]
        [string]$path,
        [Parameter(Mandatory)]
        [string]$fileName,
        [string]$fileExtension
    )

    if (!$path -or !$fileName) {
        Write-Host "Please provide a path and a newFileName" -ForegroundColor "red"
        return
    }

    $count = 1

    if (!$fileExtension) {
        $files = Get-ChildItem -Path $path
    } else {
        $files = Get-ChildItem -Path $path -Filter "*.$fileExtension"
    }

    $files | ForEach-Object {
        $newFileName = $fileName + $count + $_.Extension

        $fullFilePath = $path + "\" + $_

        Rename-Item -Path $fullFilePath -NewName $newFileName
        $count++
    }
}

function Remove-BinObj {
    param (
        [string]$Path
    )

    if ($Path) {
        Get-ChildItem -Path $Path -include bin,obj -Force -Recurse  -ErrorAction SilentlyContinue `
        | remove-item -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Host "Error - Please provide a project location" -ForegroundColor "Red"
    }
}