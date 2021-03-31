terraform {

  required_version = ">= 0.14, < 0.15"

  # No se permiten variables en la configuración del backend (se debe copiar tal cual)
  # ¡IMPORTANTE! La key debe cambiar para cada módulo o sobreescribirá otro estado provocando un error.
  backend "azurerm" {

    # SE DEBE CAMBIAR ESTA LÍNEA EN CADA MÓDULO/ENTORNO
    key = "ejercicio5/pre/database/terraform.tfstate"

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

data "terraform_remote_state" "common" {
  backend = "azurerm"

  config = {
    key    = "ejercicio5/pre/common/terraform.tfstate"
    resource_group_name   = "tstatesw"
    storage_account_name  = "tstatesw14165"
    container_name        = "tstatesw"
  }
}

resource "random_password" "admin_login_password" {
  length = 16
  special = false
}

resource "azurerm_mysql_server" "example" {
  name                = "example-mysqlserver"
  location            = data.terraform_remote_state.common.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.common.outputs.resource_group_name

  administrator_login          = "mysqladminun"
  administrator_login_password = random_password.admin_login_password.result

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false # true
#  ssl_minimal_tls_version_enforced  = "TLS1_2"
}