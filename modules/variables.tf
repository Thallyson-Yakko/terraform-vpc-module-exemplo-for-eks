variable "project_name" {
    type = string
    default = "hubii-project"
  
}

variable "region" {
    type = string
    default = "us-east-1"
  
}



variable "cidr_block" {
    description = "bloco cidr values"
    type = string
    default = "10.0.0.0/16"

  
}

variable "vpc_additional_cidrs" {
        type = list(string)
        description = "Lista de CIDR's adicionais da VPC"
        default = [  ]
  
}


variable "public_subnet" {
    default = {
        "subnet-pub-1a"  = { cidr = "10.0.48.0/24", az = "us-east-1a", public = true  }
        "subnet-pub-1b"  = { cidr = "10.0.49.0/24", az = "us-east-1b", public = true  }
        "subnet-pub-1c"  = { cidr = "10.0.50.0/24", az = "us-east-1c", public = true  }
    }
  
}


variable "priv_subnet" {
    default = {
        "subnet-priv-1a"  = { cidr = "10.0.0.0/20", az = "us-east-1a", public = false  }
        "subnet-priv-1b"  = { cidr = "10.0.16.0/20", az = "us-east-1b", public = false  }
        "subnet-priv-1c"  = { cidr = "10.0.32.0/20", az = "us-east-1c", public = false  }
    }
  
}

variable "database_subnet" {
    default = {
        "subnet-database-1a"  = { cidr = "10.0.51.0/24", az = "us-east-1a", public = false  }
        "subnet-database-1b"  = { cidr = "10.0.52.0/24", az = "us-east-1b", public = false  }
        "subnet-database-1c"  = { cidr = "10.0.53.0/24", az = "us-east-1c", public = false  }
    }
  
}

variable "private_pods" {
    default = {
        "subnet-private-pods-1a"  = { cidr = "100.64.0.0/18", az = "us-east-1a", public = false }
        "subnet-private-pods-1b"  = { cidr = "100.64.64.0/18", az = "us-east-1b", public = false  }
        "subnet-private-pods-1c"  = { cidr = "100.64.128.0/18", az = "us-east-1c", public = false  }
    }
  
}