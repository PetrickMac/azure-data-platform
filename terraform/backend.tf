
# Remote state configuration
# Will be configured after storage account is created

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stpetricktfstate"
    container_name       = "tfstate"
    key                  = "adp-dev.terraform.tfstate"
  }
}