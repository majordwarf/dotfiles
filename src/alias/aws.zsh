# Identity
alias awswho="aws sts get-caller-identity"

# S3
alias s3ls="aws s3 ls"
alias s3cp="aws s3 cp"
alias s3sync="aws s3 sync"
alias s3rm="aws s3 rm"

# EC2
alias ec2ls="aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType,PrivateIpAddress,Tags[?Key==\`Name\`].Value|[0]]' --output table"
alias ec2start="aws ec2 start-instances --instance-ids"
alias ec2stop="aws ec2 stop-instances --instance-ids"

# ECS
alias ecsls="aws ecs list-clusters"
alias ecssvc="aws ecs list-services --cluster"
alias ecstasks="aws ecs list-tasks --cluster"

# Lambda
alias lamls="aws lambda list-functions --query 'Functions[].FunctionName' --output table"
alias laminvoke="aws lambda invoke --function-name"

# CloudWatch
alias cwlogs="aws logs describe-log-groups --query 'logGroups[].logGroupName' --output table"
alias cwtail="aws logs tail"

# SSM
alias ssm="aws ssm start-session --target"

# Profiles & region
alias awsprofile="export AWS_PROFILE"
alias awsregion="export AWS_DEFAULT_REGION"
alias awsprofiles="aws configure list-profiles"
