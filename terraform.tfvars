aws_region       = "us-east-1"
environment      = "dev"
vpc_cidr         = "10.0.0.0/16"
ec2_instance_type = "t3.micro"
key_name         = "my-ssh-key"  # Replace with your key pair name
ec2_ami_id       = "ami-0c55b159cbfafe1f0"

# Database credentials - in production use secrets manager
db_name          = "appdb"
db_username      = "admin"
db_password      = "ChangeMe123!"  # In production, use a secure password
