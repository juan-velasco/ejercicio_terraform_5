terraform {

  required_version = ">= 0.14, < 0.15"

  # No se permiten variables en la configuración del backend (se debe copiar tal cual)
  # ¡IMPORTANTE! La key debe cambiar para cada módulo o sobreescribirá otro estado provocando un error.
  backend "azurerm" {

    # SE DEBE CAMBIAR ESTA LÍNEA EN CADA MÓDULO/ENTORNO
    key = "ejercicio5/pre/wordpress/terraform.tfstate"

    resource_group_name  = "tstatesw"
    storage_account_name = "tstatesw14165"
    container_name       = "tstatesw"
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

data "terraform_remote_state" "common" {
  backend = "azurerm"

  config = {
    key                  = "ejercicio5/pre/common/terraform.tfstate"
    resource_group_name  = "tstatesw"
    storage_account_name = "tstatesw14165"
    container_name       = "tstatesw"
  }
}

data "terraform_remote_state" "database" {
  backend = "azurerm"

  config = {
    key                  = "ejercicio5/pre/database/terraform.tfstate"
    resource_group_name  = "tstatesw"
    storage_account_name = "tstatesw14165"
    container_name       = "tstatesw"
  }
}

resource "azurerm_container_group" "aci-example" {
  name                = "examplecontainerwp"
  location            = data.terraform_remote_state.common.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.common.outputs.resource_group_name
  ip_address_type     = "public"
  dns_name_label      = "1qa2ws3edfr45tg-examplecont"
  os_type             = "linux"

  container {
    name   = "wp"
    image  = "wordpress:latest"
    cpu    = "1"
    memory = "2"

    # sensitive_environment_variables = {
    #   WORDPRESS_DB_PASSWORD = data.terraform_remote_state.database.outputs.mysql_server_administrator_login_password
    #   # resto de parámetros...
    # }

    ports {
      port     = 80
      protocol = "TCP"
    }

  }



  tags = {
    environment = "testing"
  }
}
