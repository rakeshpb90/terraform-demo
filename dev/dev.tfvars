# Bastion node settings
bastion_instance_name = "sre-challenge-bastion"
bastion_instance_type = "t2.micro"
bastion_ssh_key       = "reshma"
az                    = "us-east-1a"
bastion_security_group_ids = ["sg-0b65e57572d934340"]
subnet_id             = "subnet-02b15c1677a635011"
bastion_ami           = "ami-007855ac798b5175e"
bastion_root_block_device = [
  {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }
]

tags = {
  Name        = "sre-challenge-bastion"
  Environment = "Dev"
  Owner       = "reshma"
  Project     = "SRE Challenge"
}

create_eip = false