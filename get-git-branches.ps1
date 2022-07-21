$branches = git branch

foreach ($branch in $branches) {
    if ($branch -match "main") {
        write-host $branch
        continue
    } if ($branch -match "release") {
        write-host $branch
        continue
    }

    write-host "Non main/release branch : $branch"
}