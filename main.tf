
# Create a VPC
resource "aws_vpc" "my_terraform_vpc" {
  cidr_block       = var.vpc_cidr_block
  tags             = var.vpc_tags
  instance_tenancy = var.vpc_instance_tenancy
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_terraform_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.aws_availability_zone

  tags = var.public_subnet_tags
}

# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_terraform_vpc.id

  tags = var.igw_tags
}

# route tables for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.public_route_table_tags
}

# route table association public subnet
resource "aws_route_table_association" "public-route-table-association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

# security group for the CLB
resource "aws_security_group" "clb_sg" {
  vpc_id = aws_vpc.my_terraform_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.clb_sg_tags
}

# security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.my_terraform_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.clb_sg.id] # Only allow traffic from the CLB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.instances_sg_tags
}

# create EC2 instances
resource "aws_instance" "server" {
  count = 2 # create two similar EC2 instances

  subnet_id                   = aws_subnet.public_subnet.id
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  availability_zone           = var.aws_availability_zone
  security_groups             = [aws_security_group.instance_sg.id]
  user_data                   = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y nginx
        systemctl start nginx
        systemctl enable nginx
        
        TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
        INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
        PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

        echo "<html><body><h1>Hello from instance $INSTANCE_ID with private ip $PRIVATE_IP using CLB</h1></body></html>" > /var/www/html/index.html
        systemctl restart nginx
        EOF

  tags = {
    Name = "Server-${count.index}"
  }
}

# create the classic load balancer
resource "aws_elb" "app_clb" {
  security_groups = [aws_security_group.clb_sg.id]
  subnets         = [aws_subnet.public_subnet.id]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  instances = aws_instance.server[*].id

  tags = var.clb_tags
}
