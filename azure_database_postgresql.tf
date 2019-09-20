variable "default_user" {}
variable "default_password" {}
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "test" {
  name     = "tf_test_01_rg"
  location = "Japan West"
}

resource "azurerm_postgresql_server" "test" {
  name                = "postgresql-keisen-1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  sku {
    name = "PGSQLB50"
    capacity = 50
    tier = "Basic"
  }

  administrator_login = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version = "9.6"
  storage_mb = "51200"
  ssl_enforcement = "Enabled"
}

resource "azurerm_postgresql_database" "test" {
  name                = "exampledb"
  resource_group_name = "${azurerm_resource_group.test.name}"
  server_name         = "${azurerm_postgresql_server.test.name}"
  charset             = "UTF8"
  collation           = "C"
}

resource "azurerm_postgresql_firewall_rule" "test" {
  name                = "AllowJumpbox"
  resource_group_name = "${azurerm_resource_group.test.name}"
  server_name         = "${azurerm_postgresql_server.test.name}"
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.17.62"
}
