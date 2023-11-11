module "bastion_ec2" {
  source              = "../modules/ec2"

  name                        = var.bastion_instance_name
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  availability_zone           = var.az
  subnet_id                   = var.subnet_id
  key_name                    = var.bastion_ssh_key
  instance_security_group_ids = var.bastion_security_group_ids
  create_eip                  = var.create_eip
  root_block_device           = var.bastion_root_block_device
  tags                        = var.tags
}