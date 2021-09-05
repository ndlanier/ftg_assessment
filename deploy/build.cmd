rem build docker image script - windows
@echo OFF
echo "Cloning Github Repository"
git clone https://github.com/ndlanier/react-resume-template.git

FOR /f "tokens=*" %%a in ('docker_latestImg.cmd') do SET latestImg = %%a
echo "Set latestImg Variable"
echo "latestImg: %latestImg%"
if /i %latestImg% == "" GOTO buildImg
if /i %latestImg% != "" GOTO incrementTag


:incrementTag
echo "Latest Image Exists"
docker images nlanier_resume --filter "before=nlanier_resume:latest" --format "{{.Tag}}" > tmpTag.txt
SET previousImg =< type tmpTag.txt
if %previousImg% == "" SET imgIndex = 0
if %previousImg% != "" SET /a imgIndex = %previousImg%
SET /a newTag = %imgIndex% + 1
docker tag %latestImg% nlanier_resume:%newTag%
echo "Image Tag Incremented"
GOTO buildImg

:buildImg
echo "Building Docker Image"
cd .\react-resume-template\
docker build -t nlanier_resume .
echo "Tagging for AWS Repository"
docker tag nlanier_resume:latest 476540849243.dkr.ecr.us-east-2.amazonaws.com/demo-repo:latest

