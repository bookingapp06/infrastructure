resource "aws_s3_bucket" "ebs" {
  bucket = "booking-api-production-docker-config"
}

resource "aws_s3_object" "ebs_deployment" {
  depends_on = [local_file.ebs_docker_config]
  bucket     = aws_s3_bucket.ebs.id
  key        = "Dockerrun.aws.json"
  source     = "${path.module}/Dockerrun.aws.json"
  lifecycle {
    replace_triggered_by = [ local_file.ebs_docker_config ]
  }
}

data "template_file" "ebs_docker_config" {
  template = file("${path.module}/Dockerrun.aws.json.tpl")
  vars = {
    image_name = "${var.ecr_url}:${var.image_version}"
  }
}

resource "local_file" "ebs_docker_config" {
  content  = data.template_file.ebs_docker_config.rendered
  filename = "${path.module}/Dockerrun.aws.json"
}
