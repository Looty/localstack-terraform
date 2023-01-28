terraform {
  required_providers {
    # Because we're currently using a built-in provider as
    # a substitute for dedicated Terraform language syntax
    # for now, test suite modules must always declare a
    # dependency on this provider. This provider is only
    # available when running tests, so you shouldn't use it
    # in non-test modules.
    test = {
      source = "terraform.io/builtin/test"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
}

module "main" {
  # source is always ../.. for test suite configurations,
  # because they are placed two subdirectories deep under
  # the main module directory.
  source = "../../module/bucket"

  name          = ""
  force_destroy = false

  # This test suite is aiming to test the "defaults" for
  # this module, so it doesn't set any input variables
  # and just lets their default values be selected instead.
}

# As with all Terraform modules, we can use local values
# to do any necessary post-processing of the results from
# the module in preparation for writing test assertions.
locals {
  # This expression also serves as an implicit assertion
  # that the base URL uses URL syntax; the test suite
  # will fail if this function fails.
  bucket_domain_name_length = length(module.main.name)
}

# The special test_assertions resource type, which belongs
# to the test provider we required above, is a temporary
# syntax for writing out explicit test assertions.
resource "test_assertions" "bucket" {
  # "component" serves as a unique identifier for this
  # particular set of assertions in the test results.
  component = "bucket"

  # equal and check blocks serve as the test assertions.
  # the labels on these blocks are unique identifiers for
  # the assertions, to allow more easily tracking changes
  # in success between runs.

  check "bucket_domain_name" {
    description = "bucket domain name length is not empty"
    condition   = local.bucket_domain_name_length > 0
  }

  equal "region" {
    description = "bucket region must be us-east-1"
    got         = module.main.region
    want        = "us-east-1"
  }

  equal "false_destroy" {
    description = "false_destroy must be true"
    got         = module.main.force_destroy
    want        = true
  }
}
