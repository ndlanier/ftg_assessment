# Issues List

The following file documents the issues I ran into and how I would/have resolved the issues.

------
### Configure Container Logs/access logs to go to ES

**Issue:** Unable to manually create subscription filter. *Start Streaming* button dithered.

**Root Cause:** Likely do to free tier use. I see the following warning after selecting the Lambda IAM Execution Role,
![ES Log Subscriptioon Filter Warning](/img/eslog_warning.PNG)

**Attempted Workaround:** Created a budget as suggested by the warning to limit my spending to $0.01. However, the warning persisted and the *Start Streaming* button is still dithered.
![Budget set up to attempt to clear warning](/img/budget.PNG)

**Potential Resolution:** Ensure that I don't need to specify a subscription filter pattern or subscription filter name.
![Current settings for log format and filters](/img/logformat.PNG)