$accountID = Get-Content -Path .\secret.txt -TotalCount 1
$region = (Get-Content -Path .\secret.txt -TotalCount 2)[-1]
Write-Output "Logging into AWS ECR"
$loginURI = "$accountID.dkr.ecr.$region.amazonaws.com"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $loginURI
Write-Output "Pushing docker image to image repo"
$pushURI = "$accountID.drk.ecr.$region.amazonaws.com/demo-repo:latest"
docker push $pushURI
Write-Output "Image Deployed!"