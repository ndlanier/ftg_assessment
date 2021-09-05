# Security Concerns

## Summary
As you publish or host anything in an internet facing fashion, there is always at least one security threat. Even if you hosted an isolated intranet application there is always a wait that it is vulnerable. Weather that's through utility infrastructure, network infrastructure, or physical access. It makes live monitoring of all aspects of access to whatever you're hosting nothing short of required. 

## Specific Security Concerns

### Aplication/Docker Image Concerns
- Currently utilizing HTTP, HTTPS would be preferred for its encryption. In the case of this application no data is exchanging between user or the application there is no immediate security concern.
- The usage of docker in general as docker requires root permissions on the host.

### Networking Infrastructure
- At the moment I am only allowing TCP ports 80 and 8888 for inbound traffic on my security group. However, I have all outbound traffic allowed. Ideally I would want to clamp this down to only to whatever ports I need it to use going out to prevent the EC2 instances from being utilized for malicious reasons through unkown ports.
- For the sake of convenience, I am only navigating to the application tied to load balancer via the public dns hostname of the load balancer. Best practice would dictate to put access to that load balancer behind an a more private DNS hostname to obfuscate where/how the application is being hosted.

### Terraform Configuration
- In some of my Terraform configuration files, I explicitely refer to some arns/ids. In doing so this has revieled my AWS account ID and region that I utilize for some of these services. In production I should avoid manually referencing these items and should attempt to pull the arns/ids programmatically. Exposing such information in plaintext presents a possible attack vector.

### Other Concerns
- Running my linux box with root permissions to manage terraform deployments.
- Hosting a samba share on my linux box to store the github repo locally.
- Utilizing one user for aws tasks isntead of creating specific service accounts with specific IAM roles.