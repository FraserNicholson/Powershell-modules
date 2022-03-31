function Start-DimensionAutomatedImport([string] $clientCode) {
    if (!$clientCode) {
        $clientCode = "buildtrack"
    }

    Move-Item -Path "C:\Projects\Enable\Core\Source\Web\ClientsSftp\$clientCode\Imports\*" -Destination "C:\Projects\Enable\Automated Imports\src\AutomatedCollectionImportService\bin\Debug\Imports\$clientCode\Imports"

    $currentDirectory = Get-Location

    cd "C:\Projects\Enable\Automated Imports\src\AutomatedCollectionImportService"

    iex "dotnet run"

    Start-Sleep -s 15
}

function Move-DimensionImport([string] $clientCode) {
    if (!$clientCode) {
        $clientCode = "buildtrack"
    }

    Move-Item -Path "C:\Projects\Enable\Core\Source\Web\ClientsSftp\$clientCode\Imports\*" -Destination "C:\Projects\Enable\Automated Imports\src\AutomatedCollectionImportService\bin\Debug\Imports\$clientCode\Imports"

}