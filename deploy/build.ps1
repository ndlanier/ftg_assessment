$accountID = Get-Content -Path .\secret.txt -TotalCount 1
$region = (Get-Content -Path .\secret.txt -TotalCount 2)[-1]
Write-Output $accountID
Write-Output $region
New-Item -ItemType Directory -Path buildFiles
cd buildFiles
git clone https://github.com/ndlanier/react-resume-template.git

$latestImg = (docker images nlanier_resume:latest -q)


if ($latestImg -ne "") { #increment tag
    Write-Output "Latest image exists!"
    Write-Output "Latest image id: $latestImg"
    $prevImg = (docker images nalnier_resume --filter "before=nlanier_resume:latest" --format "{{.Tag}}")
    if ($prevImg -eq $null) {
        $imgIndex = 1
    }
    elseif ($prevImg -ne $null) {
        $imgIndex = [int]$prevImg + 1
    }
    else {
        Write-Output "Previous Image Tag Error... Exiting"
        exit
    }
    Write-Output "Tagging $latestImg with tag index $imgIndex"
    docker tag $latestImg nlanier_resume:$imgIndex
}
elseif ($latestImg -eq "") { 
    Write-Output "Latest image does not exist..."
}
else {
    Write-Output "Latest Image Validation Error... Exiting"
    exit
}

#build docker image
cd react-resume-template
Write-Output "Building Image"
docker build -t nlanier_resume .
Write-Output "Image Built"
Write-Output "Checking if AWS Tagged Image Exists..."
$latestAWS = (docker images $accountID.dkr.ecr.us-east-2.amazonaws.com/demo-repo:latest -q)


if ($latestAWS -ne "") { #increment tag
    Write-Output "Latest AWS image exists!"
    Write-Output "Latest AWS image id: $latestAWS"
    $prevAWS = (docker images $accountID.dkr.ecr.us-east-2.amazonaws.com/demo-repo --filter "before=$accountID.dkr.ecr.$region.amazonaws.com/demo-repo:latest" --format "{{.Tag}}")
    if ($prevAWS -eq $null) {
        $awsIndex = 1
    }
    elseif ($prevAWS -ne $null) {
        $awsIndex = [int]$prevAWS + 1
    }
    else {
        Write-Output "Previous AWS Image Tag Error... Exiting"
        exit
    }
    Write-Output "Tagging $latestAWS with tag index $awsIndex"
    docker tag $accountID.dkr.ecr.us-east-2.amazonaws.com/demo-repo $accountID.dkr.ecr.$region.amazonaws.com/demo-repo:$awsIndex
}
elseif ($latestImg -eq "") { 
    Write-Output "Latest AWS image does not exist..."
}
else {
    Write-Output "Latest AWS Image Validation Error... Exiting"
    exit
}

Write-Output "Tagging for AWS"
$tagURI = "$accountID.dkr.ecr.$region.amazonaws.com/demo-repo:latest"
docker tag nlanier_resume:latest $tagURI
Write-Output "Build complete"
cd .. #out of repo clone
cd .. #out of build files
Remove-Item buildFiles -Recurse