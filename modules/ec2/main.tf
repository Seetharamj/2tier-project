resource "aws_instance" "instance" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, count.index)
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  user_data              = var.user_data

  tags = merge(
    var.tags,
    {
      Name = "${lookup(var.tags, "Name", "ec2-instance")}-${count.index + 1}"
    }
  )
}

resource "aws_lb_target_group_attachment" "web" {
  count            = lookup(var.tags, "Tier", "") == "web" ? var.instance_count : 0
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.instance[count.index].id
  port             = 80
}
