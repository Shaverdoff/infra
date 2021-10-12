# REMOTE STATE
1) minio with http under nginx proxy
2) add backend to the main.tf
```
terraform {
  backend "s3" {
    access_key = "miniorv"
    secret_key = "SKFzHq5iDoQgW1gyNHYFmnNMYSvY9ZFMpH"
    endpoint = "http://ms3.rendez-vous.ru"
    region = "main"
    bucket = "terraform-state"
    key = "vm/terraform.tfstate"
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
#Invalid AWS Region: main
    skip_region_validation = true
    force_path_style = true
  }
}
```
