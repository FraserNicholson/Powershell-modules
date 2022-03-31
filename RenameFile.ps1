$filePath = Read-Host "Enter a path to rename files in"
$newBaseFileName = Read-Host "Enter the base file name"

$count = 1

Get-ChildItem -Path $filePath | ForEach-Object {
    $newFileName = $newBaseFileName + $count + $_.Extension

    $fullFilePath = $filePath + "\" + $_

    Rename-Item -Path $fullFilePath -NewName $newFileName
    $count++
}