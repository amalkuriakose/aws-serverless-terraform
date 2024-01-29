resource "terraform_data" "delete_zip_archive" {
  provisioner "local-exec" {
    when = destroy
    # For linux/macos, use rm command
    command = "del lambda_function.zip"
  }
}