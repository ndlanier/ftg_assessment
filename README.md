# Example AWS Deployment Utilizing Terraform

## Table of Contents
- [Example AWS Deployment Utilizing Terraform](#example-aws-deployment-utilizing-terraform)
  - [Table of Contents](#table-of-contents)
  - [Project Summary](#project-summary)
  - [File Structure](#file-structure)
  - [Task List](#task-list)
  - [Bonus Tasks](#bonus-tasks)
  - [Main Objectives](#main-objectives)

-----------------

## Project Summary
This project is to build an example deployment in AWS utilizing Terrarform as much as possible. I have the majority of the infrastructure of the deployment created with Terraform.

The container being utilized was created utilizing the node 13.12.0-alpine image to containerize a reactjs based resume app that I built from a template. See [this repo for application code](https://github.com/ndlanier/react-resume-template).

------------

## File Structure
- [deploy](deploy)
  - [build.ps1](deploy/build.ps1)    | builds docker image from repo and tags it for push to AWS ECR
  - [deploy.ps1](deploy/deploy.ps1)  | logs into AWS ECR and pushes image to ECR repo
  - secret.txt  | included in .gitignore | contains AWS account id and region 
- [doc](doc)
  - [issues.md](doc/issues.md) | List of current unresolved issues
  - [securityConcers.md](doc/securityConcerns.md) | Suggestions/Concerns on potential security issues of the deployment
- img | Directory for storing images for reference in documentation
  - *.PNG
- .gitignore
- README.md
- ec2_group.tf | definitions relevant to ec2 instances
- ecs.tf | definitions relevant to ecs cluster configuration and infrastructure
- iam.tf | IAM role definitions
- image_repo.tf | ecr definition
- main.tf
- networking.tf | networking infrastructure related definitions
- output.tf | declaration of output variables
- provider.tf
- terraform.tfvars
- vars.tf

------------

## Task List
- [x] Set up an AWS account
- [x] Set up AWS-managed Elasticsearch in a VPC
- [x] Pick a web server container image and deploy/run in AWS behind an ELB
  - [x] ECR Created
  - [x] Docker Image Uploaded - See [this repo for application code](https://github.com/ndlanier/react-resume-template)
    - [x] Manually
    - [ ] Scripted
      - Scripting issues with aws ecs not see variables properly. See [issues.md](doc/issues.md)
  - [x] ECS Cluster Created
  - [x] ELB Created
- [ ] Configure container logs/access logs to go to ES
  - [ ] Manually
    - See [issues.md](doc/issues.md)
  - [ ] Terraform
    - Container logging config was preventing containers from starting. See [issues.md](doc/issues.md)
- [x] Code in a public git repo that is used to create the infrastructure
- [x] Include a file in your repo that includes your suggestions on potential security concerns that affect your configuration
    - See [securityConcerns.md](doc/securityConcerns.md)

------------------

## Bonus Tasks
- [ ] CI Integration with the git repos to deploy
  - There are some issues with the scripts. 
  - [x] Docker Build
    - [Windows](deploy/build.cmd)
  - [x] Docker Deploy
    - [Windows](deploy/deploy.ps1)
- [ ] Use Kubernetes (EKS)
  - Did not complete
- [x] Turn in early
  - Turned in on Sunday, September 5th, 2021
- [x] Cloud Trail logs going to ES
  - [ ] Manually
    - Same issue as container logs to ES issue, see [issues.md](doc/issues.md)
  - [x] Terraform


-----------

## Main Objectives
- Best practices and security considerations in AWS
  - Utilizing 12 character random generated passwords with mixed case, number and symbols for accounts.
  - Subnet had no WAN exposure while building, only enabled once ready to test containers.
- Automation through Terraform or other means
  - Attempting most infrastructure build via Terraform as it is much easier and less time consuming than manually creating in AWS management console or through AWS CLI
  - May want to attemp a bash script to push latest docker image since it ecr require separate authentication out of AWS CLI 
- Git repo setup integration
- Preferences for tooling/methodology
  - End User Device:
    - Windows 10 PC
    - VS Code
    - Docker Desktop
    - AWS CLI
  - Linux Terminal
    - Ubuntu 20.04 LTS
    - AWS CLI
    - Terraform
      - Terraform directory hosted via authenticated samba network share and mounted to End User Device for use within VS Code.