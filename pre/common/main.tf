terraform {

  required_version = ">= 0.14, < 0.15"

  # No se permiten variables en la configuración del backend (se debe copiar tal cual)
  # ¡IMPORTANTE! La key debe cambiar para cada módulo o sobreescribirá otro estado provocando un error.
  backend "azurerm" {

    # SE DEBE CAMBIAR ESTA LÍNEA EN CADA MÓDULO/ENTORNO
    key = "ejercicio5/pre/common/terraform.tfstate"

    resource_group_name   = "tstatesw"
    storage_account_name  = "tstatesw14165"
    container_name        = "tstatesw"
  }
}

# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "prefix" {
  default = "curso-azure-terraform-5"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.resource_group_location
}