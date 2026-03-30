terraform {
      backend "s3" {
    bucket = ""
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true  #Forma de bloquear o estado do backend sem precisar utilizar o dynamoDB
  }  
}