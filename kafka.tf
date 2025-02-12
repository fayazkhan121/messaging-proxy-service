resource "aws_security_group" "kafka_sg" {
  name        = "kafka_sg"
  description = "Security group for Kafka cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr]
  }
}

resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "mps-kafka-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = module.vpc.private_subnets
    security_groups = [aws_security_group.kafka_sg.id]
  }
}
