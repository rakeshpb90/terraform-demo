resource "aws_instance" "this" {
  count = var.ec2_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  monitoring             = var.monitoring
  vpc_security_group_ids = var.instance_security_group_ids

  private_ip                  = var.private_ip
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized          = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      delete_on_termination = try(root_block_device.value.delete_on_termination, null)
      encrypted             = try(root_block_device.value.encrypted, true)
      iops                  = try(root_block_device.value.iops, null)
      volume_size           = try(root_block_device.value.volume_size, null)
      volume_type           = try(root_block_device.value.volume_type, null)
      throughput            = try(root_block_device.value.throughput, null)
      tags                  = merge(var.tags, { "Name" = format("%s-%d", var.name, count.index + 1) }, try(root_block_device.value.tags, null))
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = merge(var.tags, { "Name" = format("%s-%d", var.name, count.index + 1) }, try(ebs_block_device.value.tags, null))
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device

    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = try(ephemeral_block_device.value.no_device, null)
      virtual_name = merge(var.tags, try(ephemeral_block_device.value.virtual_name, null))
    }
  }

  source_dest_check                    = var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  availability_zone                    = var.availability_zone
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy

  tags = tomap(merge(var.tags, { "Name" = format("%s-%d", var.name, count.index + 1) }))
}

resource "aws_eip" "this" {
  count = var.create_eip ? 1 : 0
  vpc      = true
  tags = merge(var.tags, { "Name" = format("%s-EIP", var.name) })
}


resource "aws_eip_association" "eip_assoc" {
  count = var.create_eip ? 1 : 0
  instance_id   = aws_instance.this[0].id
  allocation_id = aws_eip.this[0].id
}
