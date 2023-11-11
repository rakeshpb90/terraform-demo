variable "bastion_instance_name" {
  description = "The name of the bastion instance"
}

variable "bastion_ami" {
  description = "The AMI ID for the bastion instance"
}

variable "bastion_instance_type" {
  description = "The EC2 instance type for the bastion"
}

variable "az" {
  description = "The availability zone for the bastion instance"
}

variable "subnet_id" {
  description = "The ID of the subnet where the bastion instance will be launched"
}

variable "bastion_ssh_key" {
  description = "The SSH key name for accessing the bastion instance"
}

variable "bastion_security_group_ids" {
  description = "A list of security group IDs for the bastion instance"
  type        = list(string)
}

variable "create_eip" {
  description = "Whether to associate an Elastic IP (EIP) with the bastion instance"
  type        = bool
}

variable "bastion_root_block_device" {
  description = "Root block device configuration for the bastion instance"
}

variable "tags" {
  description = "A map of tags to apply to the bastion instance"
  type        = map(string)
}
