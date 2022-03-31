Import-Module -Name "C:\Projects\Powershell modules\projects"

function GitCommands {
    $currentDirectory = Get-Location
    $projectBasePath = "C:\Projects\Enable\"

    $commandInput = Get-CommandInput

    $projects = Get-ProjectList

    $projectsToCommand = Read-ProjectsInput

    Write-Host $projectsToCommand

    $useAllProjects = $false;

    if (!$projectsToCommand) {
        return
    }

    if ($projectsToCommand -eq 'a') {
        $useAllProjects = $true
    }

    switch ( $commandInput ) 
    {
        'p' { GitPull($projectsToCommand) -useAllProjects:$useAllProjects }
        'c' { GitCustomCommand($projectsToCommand) }
    }

    Set-Location $currentDirectory
}

function GitPushCurrentBranch {
    $currentBranch = &git rev-parse --abbrev-ref HEAD 

    Invoke-Expression "git push --set-upstream origin $currentBranch"
}

function GitPull([System.Collections.ArrayList]$projectsToPull, [switch]$useAllProjects) {

    $branch = read-host "Specify the branch you want to pull main from, if none is specified main will be used"

    if (!$branch) {
        $branch = "main"
    }

    if ( $useAllProjects ) {
        write-host "Pulling from all projects" -foreground 'green'

        $projects.Keys | ForEach-Object {
            $project = $_
            $projectLocation = $projectBasePath + $project

            Set-Location $projectLocation

            $hasGitChanges = Get-HasGitChanges

            if ($hasGitChanges) {
                Write-Host "Warning - command may fail as you have uncommited changes or untracked files in $project" -ForegroundColor 'Red'
            }

            write-host "Pulling latest on $branch from $project" -foreground 'green'
            Invoke-Expression "git checkout $branch"
            Invoke-Expression "git pull"
        }
    }

    Foreach ($num in $projectsToPull) {
        $projects.Keys | Where-Object { $projects[$_] -eq $num } | ForEach-Object {
            $project = $_
            $projectLocation = $projectBasePath + $project

            Set-Location $projectLocation

            $hasGitChanges = Get-HasGitChanges

            if ($hasGitChanges) {
                Write-Host "Warning - command may fail as you have uncommited changes or untracked files in $project" -ForegroundColor 'Red'
            }

            write-host "Pulling latest on $branch from $project" -foreground 'green'
            Invoke-Expression "git checkout $branch"
            Invoke-Expression "git pull"
        }
    }

    Set-Location $currentDirectory
}

function GitCustomCommand([System.Collections.ArrayList] $projectsToCommand) {

    $command = read-host "Enter git command"

    if ($command) {
            Foreach ($num in $projectsToCommand) {
            $projects.Keys | Where-Object { $projects[$_] -eq $num } | ForEach-Object {
                $project = $_
                $projectLocation = $projectBasePath + $project

                Set-Location $projectLocation

                $hasGitChanges = Get-HasGitChanges

                if ($hasGitChanges) {
                    Write-Host "Warning - command may fail as you have uncommited changes or untracked files in $project" -ForegroundColor 'Red'
                }

                write-host "Executing git command in $project" -foreground 'green'
                Invoke-Expression $command
            }
        }

        Set-Location $currentDirectory
    }
}

function Get-CommandInput {
    write-host "p - git pull" -foreground "Cyan"
    write-host "c - custom command" -foreground "Cyan"

    $commandInput = read-host "Select a git command option"

    return $commandInput
}

function Get-HasGitChanges {
    $gitStatus = git status --porcelain

    if($gitStatus |Where-Object {$_ -match '^\?\?'}){
        return $true
    } 
    elseif($gitStatus |Where-Object {$_ -notmatch '^\?\?'}) {
        return $true
    }
    else {
        return $false
    }
}