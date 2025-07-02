resource "aws_db_subnet_group" "db" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier              = var.db_name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  storage_encrypted      = true

  tags = {
    Name = var.db_name
  }
}
