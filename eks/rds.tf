/*
  Configures an RDS MySQL instance for a persistent datastore
  Configures a security group allowing ingress from the EKS cluster worker nodes
*/
resource "aws_db_subnet_group" "db" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${var.app_name}-db-subnet-group"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.app_name}-db-security_group"
  description = "Allow inbound and outbound traffic to db"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.cluster_primary_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-db-security_group"
  }
}

resource "aws_db_parameter_group" "db" {
  name   = "${var.app_name}-db-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = 1
  }
}

resource "aws_db_instance" "db" {
  allocated_storage                   = 20
  backup_retention_period             = 0
  db_subnet_group_name                = aws_db_subnet_group.db.name
  deletion_protection                 = false
  enabled_cloudwatch_logs_exports     = []
  engine                              = "mysql"
  engine_version                      = "8.0"
  iam_database_authentication_enabled = false
  identifier                          = "${var.app_name}-db-instance"
  iops                                = 0
  instance_class                      = "db.t2.small"
  max_allocated_storage               = 0
  multi_az                            = "true"
  name                                = var.db
  parameter_group_name                = aws_db_parameter_group.db.name
  password                            = var.db_password
  storage_type                        = "gp2"
  skip_final_snapshot                 = "true"
  security_group_names                = []
  username                            = var.db_username
  vpc_security_group_ids              = [aws_security_group.db.id]

  tags = {
    Name = "${var.app_name}-db"
  }
}