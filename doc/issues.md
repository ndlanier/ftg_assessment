# Issues List

The following file documents the issues I ran into and how I would/have resolved the issues.

------
## Configure Container Logs/access logs to go to ES

**Issue:** Unable to manually create subscription filter. *Start Streaming* button dithered.

**Root Cause:** Likely do to free tier use. I see the following warning after selecting the Lambda IAM Execution Role,
![ES Log Subscriptioon Filter Warning](/img/eslog_warning.PNG)

**Potential Resolution:** Ensure that I don't need to specify a subscription filter pattern or subscription filter name.
![Current settings for log format and filters](/img/logformat.PNG)

-----
## Container Definition & Logging Properties Preventing Startup
**Issue :** Unable to start containers after adding parameters to container definition to enable cloudwatch logging.

Code Removed that was located in ecs.tf under ECS-ResumeApp-Stask in the container_definitions:
```
{
    "logConfiguration":{
          "logDriver": "awslogs",
          "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "sonny-logs",
            "awslogs-region": "us-east-2",
            "awslogs-stream-prefix": "${var.app_name}-CloudTrail_us-east-2"
          }
}
```

**Root Cause:** I am now unable to find the task logs (likely auto purged), the error that I did see in the task logs was that the execution role did not have the rights to log. I tried adding some roles to the ecs_agent but was still unable to get the tasks started.

**Potential Resolution:** Figure out what exact IAM role is needed to allow loging to CloudWatch and ECS. Ensure that the above codeblock would create the proper configuration.

------
## Docker Build/Deploy Script Issues
**Issue 1:** Variables not being read properly when exuting docker commands.

The following command will not execute properly as it was consistantly only seeing /demo-repo:latest instead of the entire URI.
```
docker tag nlanier_resume:latest $accountID.dkr.ecr.$region.amazonaws.com/demo-repo:latest
```
**Resolution:** Compiled the entire URI into a variable. Need to possibly implement on other docker commands in the scripts.
```
$tagURI = "$accountID.dkr.ecr.$region.amazonaws.com/demo-repo:latest"
docker tag nlanier_resume:latest $tagURI
```

**Issue 2:** Images past tag of 1 (so tag 2, 3, 4, so on) are being lost.

**Potential Resolution:** The script has if elseif blocks to handle incrementing the tags, these statements likely need re-worked as they may have improper logic. Or my docker install is not playing nice with the script in this regard. Could also be caused by the variable issue.


**Issue 3:** Unable to push image to aws ecr without first disabling Tag immutability manually.

**Potential Resolution:** There is likely a way to disable this from the available commands with aws CLI.