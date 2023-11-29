terraform {
  required_providers {
  azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.80.0"
    }
   kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }

/*
  backend "azurerm" {
     resource_group_name  = "tfstate"
     storage_account_name = "<storage_account_name>"
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
  }
*/

}

/*
provider "azurerm" {
  features {}
  // skip_provider_registration = true
  // use_cli = false
  // use_oidc = true
}
*/


/*
resource "azurerm_resource_group" "state-demo-secure" {
 name     = "plf-state-demo-1"
 location = "West Europe"
}
*/

resource "kubernetes_deployment" "redis" {
  metadata {
    name = var.redis_cache_name  // "redis-${sha512(var.context.resource.id)}"
    namespace = var.context.runtime.kubernetes.namespace
    labels = {
      app = "redis"
    }
  }
  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "redis"
        resource = var.context.resource.name
      }
    }
    template {
      metadata {
        labels = {
          app = "redis"
          resource = var.context.resource.name
        }
      }
      spec {
        container {
          name  = "redis"
          image = "redis:6" 
          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name = var.redis_cache_name // "redis-${sha512(var.context.resource.id)}"
    namespace = var.context.runtime.kubernetes.namespace
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "redis"
      resource = var.context.resource.name
    }
    port {
      port        = var.port
      target_port = "6379"
    }
  }
}
