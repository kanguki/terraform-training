locals {
  name       = "${var.env}-terraform-aws-course"
  aws_region = "ap-southeast-1"
  vpc_cidr   = "10.123.0.0/16"
  public_subnets = [
    {
      cidr = cidrsubnet(local.vpc_cidr, 8, 2) # divide the vpc into 8 subnets, pick 2nd subnet 
      az   = "ap-southeast-1a"
    },
    {
      cidr = cidrsubnet(local.vpc_cidr, 8, 3)
      az   = "ap-southeast-1b"
    }
  ]
  private_subnets = [
    {
      cidr = cidrsubnet(local.vpc_cidr, 8, 1)
      az   = "ap-southeast-1c"
    },
  ]
  ami_focal_amd64_ap_southeast_1 = "ami-02ed1086955fbf51f"
  num_private_http_servers       = 2
  num_public_http_servers        = 1
  local_secret_dir               = "${path.root}/secrets"
  local_path_for_private_file    = "${local.local_secret_dir}/id_rsa"
  http_port = 8080
}

module "networking" {
  source          = "./networking"
  system_name     = local.name
  vpc_cidr        = local.vpc_cidr
  tags            = {}
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

############################
# http servers
############################
resource "aws_launch_template" "bash_http_server" {
  image_id               = local.ami_focal_amd64_ap_southeast_1
  name                   = "bash_http_server"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.admin.key_name
  vpc_security_group_ids = [aws_security_group.http_server.id]
  user_data              = filebase64("${path.root}/files/start-http-server.sh")
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
}

resource "aws_instance" "public_bash_http_worker" {
  count         = local.num_public_http_servers
  ami           = local.ami_focal_amd64_ap_southeast_1
  instance_type = "t2.micro"
  subnet_id     = module.networking.public_subnet_ids[count.index % length(module.networking.public_subnet_ids)]
  launch_template {
    id = aws_launch_template.bash_http_server.id
  }
  tags = {
    Name = "${local.name}-public-http-worker-${count.index}"
  }
}

resource "aws_instance" "private_bash_http_worker" {
  count         = local.num_private_http_servers
  ami           = local.ami_focal_amd64_ap_southeast_1
  instance_type = "t3.micro"
  subnet_id     = module.networking.private_subnet_ids[count.index % length(module.networking.private_subnet_ids)]
  launch_template {
    id = aws_launch_template.bash_http_server.id
  }
  tags = {
    Name = "${local.name}-private-http-worker-${count.index}"
  }
}


resource "aws_security_group" "http_server" {
  vpc_id = module.networking.vpc_id
  ingress {
    description     = "allow ssh from bastion "
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  ingress {
    description = "allow connection from within the vpc to http port "
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }
  egress {
    description = "allow connection to the whole internet"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.name}-http-worker"
  }
}


############################
# bastion
############################
resource "aws_instance" "bastion" {
  ami                         = local.ami_focal_amd64_ap_southeast_1
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.admin.key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  subnet_id                   = module.networking.public_subnet_ids[0]
  tags = {
    Name = "${local.name}-bastion"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = module.networking.vpc_id
  ingress {
    description = "allow connection from the whole internet "
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow connection to the whole internet"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.name}-bastion"
  }
}

############################
# key pair
############################
## Generate PEM (and OpenSSH) formatted private key.
resource "tls_private_key" "ec2_bastion_host_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
## Save Public Key locally
resource "local_file" "ec2_bastion_host_public_key" {
  content  = tls_private_key.ec2_bastion_host_key_pair.public_key_openssh
  filename = "${local.local_path_for_private_file}.pub"
}
## Save Private Key locally
resource "local_sensitive_file" "ec2_bastion_host_private_key" {
  content         = tls_private_key.ec2_bastion_host_key_pair.private_key_pem
  filename        = local.local_path_for_private_file
  file_permission = "0400"
}
## AWS SSH Key Pair
resource "aws_key_pair" "admin" {
  depends_on = [local_file.ec2_bastion_host_public_key]
  key_name   = "${local.name}-terraform-generated"
  public_key = tls_private_key.ec2_bastion_host_key_pair.public_key_openssh
}

resource "local_file" "ssh_config" {
  content = templatefile("${path.root}/files/ssh_config.tftpl", {
    bastion     = aws_instance.bastion.public_ip
    private_key = local.local_path_for_private_file
    workers = merge({
      for idx, w in aws_instance.public_bash_http_worker[*] : "public-${idx}" => w.private_dns
      }, {
      for idx, w in aws_instance.private_bash_http_worker[*] : "private-${idx}" => w.private_dns
    })
  })
  filename = "${local.local_secret_dir}/config"
}
