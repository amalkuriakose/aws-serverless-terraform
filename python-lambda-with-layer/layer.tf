resource "terraform_data" "create_layer_file" {
  provisioner "local-exec" {
    command = "mkdir ${var.lambda_layer_name}\\python"
  }
  provisioner "local-exec" {
    # Use pip3 on linux/mac. Please modify this command as per your use case.
    command = "pip install -r requirements.txt -t ${var.lambda_layer_name}\\python\\ --platform manylinux2014_x86_64 --python-version 3.12 --only-binary=:all:"
  }
}

data "archive_file" "lambda_layer_archive_file" {
  type        = "zip"
  source_dir  = var.lambda_layer_name
  output_path = "${var.lambda_layer_name}.zip"
  depends_on  = [terraform_data.create_layer_file]
}

resource "aws_s3_bucket" "lambda_layer_bkt" {
  bucket = var.lambda_layer_bkt_name

  tags = merge(
    local.common_tags,
    {
      Name = var.lambda_layer_bkt_name
    }
  )
}

resource "aws_s3_object" "object" {
  bucket = var.lambda_layer_bkt_name
  key    = "${var.lambda_layer_name}.zip"
  source = "${var.lambda_layer_name}.zip"
  etag = data.archive_file.lambda_layer_archive_file.output_md5
  depends_on = [data.archive_file.lambda_layer_archive_file]
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = var.lambda_layer_name
  compatible_runtimes = ["python3.12"] # Change the compatable runtime based on your preference
  s3_bucket           = var.lambda_layer_bkt_name
  s3_key              = "${var.lambda_layer_name}.zip"
  depends_on          = [aws_s3_object.object]
}