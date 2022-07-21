param(
    [string[]]
    $PathFilters,

    [string[]]
    $FileExtensions,

    [string]
    $PathFilterVariableToSet,

    [string]
    $FileExtensionVariableToSet
)

$ChangedFiles=$(git diff HEAD HEAD~ --name-only)

if ($PathFilters.Count -gt 0) {
    $Matched = $false

    foreach ($PathFilter in $PathFilters) {
        $MatchCount=0
    
        foreach ($File in $ChangedFiles) {
            if ($File -match $PathFilter) {
                Write-Output "Match:  ${File} changed"
                $MatchCount=$(($MatchCount+1))
                $Matched = $true
            }
        }
    
        Write-Output "$MatchCount match(es) for filter '$PathFilter' found."
    }

    if ($Matched) {
        Write-Output "##vso[task.setvariable variable=$PathFilterVariableToSet;isOutput=true]true"
    }
    else {
        Write-Output "##vso[task.setvariable variable=$PathFilterVariableToSet;isOutput=true]false"
    }
}

if ($FileExtensions.Count -gt 0) {
    $Matched = $false

    foreach ($FileExtension in $FileExtensions) {
        $MatchCount=0
    
        foreach ($File in $ChangedFiles) {
            $Extension = ((Split-Path $File -Leaf)).Split('.')[1]

            if ($Extension -eq $FileExtension) {
                Write-Output "Match:  ${File} changed"
                $MatchCount=$(($MatchCount+1))
                $Matched = $true
            }
        }
    
        Write-Output "$MatchCount match(es) for file extension '$FileExtension' found."
    }

    if ($Matched) {
        Write-Output "##vso[task.setvariable variable=$FileExtensionVariableToSet;isOutput=true]true"
    }
    else {
        Write-Output "##vso[task.setvariable variable=$FileExtensionVariableToSet;isOutput=true]false"
    }
}

