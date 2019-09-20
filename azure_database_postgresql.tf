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
  name     = "suga-rsg"
  location = "Japan East"
}

resource "azurerm_postgresql_server" "test" {
  name                = "suga-postgresql10-test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  sku {
    name = "GP_Gen5_2"
    capacity = 2
    tier = "GeneralPurpose"
    family = "Gen5"
  }

  storage_profile {
    storage_mb = "5120"
    backup_retention_days = 7
    geo_redundant_backup = "Disabled"
    auto_grow             = "Enabled"
    }
  
  administrator_login = "pgsqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version = "10"
  ssl_enforcement = "Enabled"
}

resource "azurerm_postgresql_database" "test" {
  name                = "exampledb"
  resource_group_name = "${azurerm_resource_group.test.name}"
  server_name         = "${azurerm_postgresql_server.test.name}"
  charset             = "UTF8"
  collation           = "C"
}

#resource "azurerm_postgresql_firewall_rule" "test" {
#  name                = "AllowJumpbox"
#  resource_group_name = "${azurerm_resource_group.test.name}"
#  server_name         = "${azurerm_postgresql_server.test.name}"
#  start_ip_address    = "10.0.17.62"
#  end_ip_address      = "10.0.17.62"
#}

resource "azurerm_sql_virtual_network_rule" "test" {
    name                = "EndpointRule"
    resource_group_name = "${azurerm_resource_group.test.name}"
    server_name         = "${azurerm_postgresql_server.test.name}"
    subnet_id           = "/subscriptions/6d5f4926-9bf3-444c-97d9-a8625ebdc56e/resourceGroups/suga-rsg/providers/Microsoft.Network/virtualNetworks/suga-vnet/subnets/suga-subnet6"
}
