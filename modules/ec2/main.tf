resource "aws_instance" "cloud_deployment" {
    for_each = toset (var.instance_type)
    ami           = var.ami_id
    instance_type = each.key

    tags = var.tags
        
}