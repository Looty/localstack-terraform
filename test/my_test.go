package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Bucket(t *testing.T) {
	t.Parallel()

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../",
		VarFiles: []string{
			"test/testing.tfvars",
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	output_name := terraform.Output(t, terraformOptions, "name")
	assert.NotEmpty(t, output_name)

	output_region := terraform.Output(t, terraformOptions, "region")
	assert.Equal(t, "us-east-1", output_region)

	output_force_destroy := terraform.Output(t, terraformOptions, "force_destroy")
	assert.Equal(t, "true", output_force_destroy)
}