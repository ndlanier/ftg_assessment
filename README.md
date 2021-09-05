# Example AWS Deployment Utilizing K8s and Terraform

## Tasklist
- [x] Set up an AWS account
- [x] Set up AWS-managed Elasticsearch in a VPC
- [x] Pick a web server container image and deploy/run in AWS behind an ELB
  - [x] ECR Created
  - [x] Docker Image Uploaded - See [this repo for application code](https://github.com/ndlanier/react-resume-template)
    - [x] Manually
    - [ ] Scripted
  - [x] ECS Cluster Created
  - [x] ELB Created
- [ ] Configure container logs/access logs to go to ES
  - [ ] Manually
    - See [issues.md](doc/issues.md)
  - [x] Terraform
- [x] Code in a public git repo that is used to create the infrastructure
- [ ] Include a file in your repo that includes your suggestions on potential security concerns that affect your configuration
    - See [securityConcerns.md](doc/securityConcerns.md)

------------------

## Bonus Tasks
- [ ] CI Integration with the git repos to deploy
  - [ ] Docker Build
    - [ ] [Windows](deploy/build.cmd)
    - [ ] [Linux](deploy/build.sh)
- [ ] Use Kubernetes (EKS)
- [ ] Turn in early
- [ ] Cloud Trail logs going to ES
  - [ ] Manually
    - Same issue as container logs to ES issue, see [issues.md](doc/issues.md)
  - [x] Terraform


-----------

### Main Objectives
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
    - Teraform
      - Teraform directory hosted via authenticated samba network share and mounted to End User Device for use within VS Code.