provider "aws" {
    region = "us-east-1"
}

provider "vault" {
  address = "http://54.172.146.208:6100"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "d7ebd9c5-a463-cfc2-7d59-3290005dff1d"
      secret_id = "538c937b-8b3d-aa67-315e-fc90f5b25781"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" 
  name  = "test-secret" 
}
resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
