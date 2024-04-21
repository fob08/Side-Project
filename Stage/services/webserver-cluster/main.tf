provider "aws" {
  region = var.region
}
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
}