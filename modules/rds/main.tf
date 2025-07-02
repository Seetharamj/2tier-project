resource "aws_security_group" "rds_sg" {
  name        = "${var.env_prefix}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL access from web servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env_prefix}-rds-sg"
    Environment = var.env_prefix
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.env_prefix}-rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name        = "${var.env_prefix}-rds-subnet-group"
    Environment = var.env_prefix
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = var.multi_az
  publicly_accessible    = false
  backup_retention_period = var.backup_retention_period

  tags = {
    Name        = "${var.env_prefix}-rds-instance"
    Environment = var.env_prefix
  }
}
