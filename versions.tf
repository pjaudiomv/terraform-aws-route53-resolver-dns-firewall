terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.38.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.1.0"
    }
  }
}


//local = {
//  source  = "hashicorp/local"
//  version = ">= 1.2"
//}
