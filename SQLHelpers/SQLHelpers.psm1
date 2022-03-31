function Enter-SQLBulkCommand {
    param (
        [Parameter(Mandatory)]
        [string]$DatabaseServer,
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $databases = invoke-sqlcmd -ServerInstance $DatabaseServer -Database "master" -Query "select name from sys.databases"

    $outfile = $ScriptPath + ".log"

    Clear-Content -Path $outfile

    foreach ($database in $databases)
    {
        Add-Content -Path $outfile -Value "================================================================================"
        Add-Content -Path $outfile -Value $database.Name

        #Execute scripts
        Invoke-Sqlcmd -ServerInstance ${DatabaseServer} -Database $database.name -InputFIle $ScriptPath -OutputAs DataRows | Format-Table | Out-File -FilePath $outfile -Append
    }
}