$projectsFilePath = "C:\Projects\projects.txt"

function Get-ProjectList {
    $projects = [Ordered]@{}

    Get-Content $projectsFilePath | Foreach-Object {
        $project = $_
        
        if ($project) {
            Get-Content $projectsFilePath | Select-String $project | Foreach-Object {
                $lineNumber = $_.LineNumber

                $projects[$project] = $lineNumber
                write-host "$lineNumber - $project"
            }
        }
    }

    return $projects
}

function Read-ProjectsInput {
    write-host "A - Use all projects" -foreground "magenta"

    [System.Array]$projectsForCommand = @()
    do {
        $num = read-host "Select a project you would like to execute a custom command on, press enter if you have finished selecting"
        if ($num -ne '') {
            $projectsForCommand += $num
        }
    }
    until ($num -eq '' -or $num -eq 'a')

    

    return $projectsForCommand
}

function ProjectCommands {
    $projects = Get-ProjectList

    write-host "A - Add another project" -foreground "magenta"
    write-host "R - Remove a project" -foreground "magenta"

    $num = read-host "Select a project command"

    if ($num -eq 'a') {
        Start-AddProject
    }

    if ($num -eq 'r') {
        Start-RemoveProject
    }

    write-host "Updated list of projects" -foreground "green"
    $projects = Get-ProjectList
}

function Start-AddProject {
    $projectToAdd = read-host "Specify the file name of the project you would like to add"

    Add-Project($projectToAdd)

    $response = "Would you like to return to the original project selection?"
    
    if ($response -eq 'y' -or $response -eq 'yes') {
        GitCommands
    }
}

function Start-RemoveProject {
    $projectToAdd = read-host "Specify the file name of the project you would like to remove"

    Remove-Project($projectToAdd)

    $response = "Would you like to return to the original project selection?"
    
    if ($response -eq 'y' -or $response -eq 'yes') {
        GitCommands
    }
}

function Get-SortedTextContent([string] $path) {
    $sortedContent = Get-Content $path | Sort-Object

    return $sortedContent
}

function Set-SortedTextContent([string] $path) {
    $sortedTextContent = Get-SortedTextContent($path)

    Set-Content $path -Value $sortedTextContent
}

function Add-Project([string] $projectName) {
    if ($projectName) {
        Add-Content $projectsFilePath -Value "$projectName"
    }

    Set-SortedTextContent($projectsFilePath)
}

function Remove-Project([string] $projectName) {
    $projectsToKeep = (Get-Content $projectsFilePath) -ne $projectName

    Set-Content $projectsFilePath -Value $projectsToKeep
}