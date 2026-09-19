# Lab 3 - EC2 Auto Scaling + AWS ALB (Terraform)

**Repo:** https://github.com/mathnap2/lab3
**Student:** mathias.napoles@iteso.mx - ID 745671

Deploys, in AWS Academy Learner Lab (`us-east-1`):

- **Launch template**: Amazon Linux 2023, `t3.micro`, Apache + `stress-ng`, detailed (1 min) monitoring
- **Auto Scaling Group**: min 1 / desired 1 / max 3, spread across the default VPC subnets, ELB health checks
- **Application Load Balancer** + target group + HTTP listener (the ASG registers/deregisters instances automatically)
- **Scaling policies + CloudWatch alarms** on the group's average CPU:
  - `cpu-high`: CPU > 50 % for 1 min -> **+1 instance** (up to 3)
  - `cpu-low`: CPU < 20 % for 2 min -> **-1 instance** (back down to 1)
- Security groups (internet -> ALB, ALB -> EC2 only)

Steady state is 1 instance. Under load the group grows to 3; when the load stops it
shrinks back to 1 (elastic).

## Usage

```bash
export AWS_PROFILE=academy      # Learner Lab credentials (include the session token)
terraform init
terraform apply
```

Open the `alb_dns_name` output in a browser.

## Load test (scale out -> 3, then scale in -> 1)

Instances have the Learner Lab `LabInstanceProfile`, so the load is triggered with SSM (no SSH):

```bash
IDS=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names lab3-asg-asg \
  --query "AutoScalingGroups[0].Instances[].InstanceId" --output text)

aws ssm send-command --document-name AWS-RunShellScript --instance-ids $IDS \
  --parameters 'commands=["nohup stress-ng --cpu 0 --timeout 600s >/dev/null 2>&1 &"]'
```

Watch the group grow to 3 instances (EC2 -> Auto Scaling groups -> Activity). The
stress ends by itself after 10 minutes (or `pkill stress-ng`); CPU drops, the low alarm
fires and the group removes the 2 extra instances, leaving 1.

## Clean up

```bash
terraform destroy
```
