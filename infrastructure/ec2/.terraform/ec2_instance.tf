module "devops_ec2" {
source = "../..//modules/ec2"

ami_id = "ami-01816d07b1128cd2d"
instance_type =["t2.micro", "t2.small", "t2.medium"]
tags = {
    Name = "dynamic_development"
 }
}