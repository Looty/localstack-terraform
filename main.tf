module "bucket" {
  source = "./module/bucket"

  name          = "ono"
  force_destroy = true
}
