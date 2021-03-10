module "network" {
  source = "git::https://github.com/slavrd/terraform-aws-basic-network.git?ref=0.4.1"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  name_prefix          = var.name_prefix
  common_tags          = var.common_tags
}

resource "aws_key_pair" "key" {
  key_name   = "${var.name_prefix}key-pair"
  public_key = file("${path.module}/../assets/kitchen-test.pub")
  tags       = var.common_tags
}

resource "aws_security_group" "allow-all" {
  name   = "${var.name_prefix}${formatdate("YYYYMMDDHHmmss", timestamp())}"
  vpc_id = module.network.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

resource "aws_instance" "test" {
  subnet_id                   = module.network.public_subnet_ids[0]
  ami                         = data.aws_ami.ubuntu-focal.image_id
  vpc_security_group_ids      = [aws_security_group.allow-all.id]
  key_name                    = aws_key_pair.key.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"

  user_data = <<-EOT
    #cloud-config
    packages:
    - redis-tools
    - stunnel
    write_files:
    - owner: root:root
      path: /etc/stunnel/redis-cli.conf
      permissions: '0644'
      content: |
        fips = no
        setuid = root
        setgid = root
        pid = /var/run/stunnel.pid
        debug = 7 
        delay = yes
        options = NO_SSLv2
        options = NO_SSLv3
        [redis-cli]
          client = yes
          accept = 127.0.0.1:6379
          connect = ${module.redis.redis_primary_endpoint}:${module.redis.redis_port}
    runcmd:
    - ['/bin/bash', '-c', 'stunnel /etc/stunnel/redis-cli.conf']
  EOT

  tags = var.common_tags
}

data "aws_ami" "ubuntu-focal" {
  most_recent = "true"
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "azs" {}

module "redis" {
  source = "../../"

  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  availability_zones         = [for az in distinct(var.private_subnet_cidrs[*].az_index) : element(data.aws_availability_zones.azs.names, az)]
  ingress_security_group_ids = [aws_security_group.allow-all.id]
  redis_auth_token           = "redis-auth-token"
  common_tags                = var.common_tags
}