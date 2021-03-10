# TFE AWS Redis

A Terraform module to provision an AWS Elastic Cache Redis for use with a TFE installation.

## Description

The module provisions the following resources

* Elasticache replication group with redis engine
* A Security Group to control access to Redis
* Elasticache subnet group

## Requirements

* Terraform `>= 0.13`
* AWS provider `~> 3.0`

## Input Variables

The available input variables for the module are described in the table below.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| name_prefix | `string` | `"tfe-"` | A string to be used as prefix for generating names of the created resources. |
| common_tags | `map(string)` | `{}` | The common tags to use with the managed resources. The default value is used as an example. |
| vpc_id | `string`  |  | Id of the VPC in which the Elasticache subnet group will be. |
| subnet_ids | `list(string)` |  | List of subnet ids to use for the Elasticache subnet group will be. |
| availability_zones | `list(string)` |  | List of availability zones in which to place the Elasticache nodes. |
| ingress_security_group_ids | `list(string)` |  | List of security group ids from which ingress traffic to the Elasticache service is allowed. |
| redis_port | `number` | `6379` | Port Redis will listen on. |
| redis_node_type | `string`  | `"cache.m4.large"` | The size of the Redis nodes. |
| redis_auth_token | `string` |  | Auth token for the Redis. |
| redis_engine_version | `string` | `"5.0.6"` | Redis engine version. |
| redis_parameter_group_name | `string` | `null` | The name of the parameter group to associate with this replication group. |

## Outputs

The output values exposed by the module are described in the table below.

| Output | Type | Description |
| ------ | ---- | ----------- |
| redis_primary_endpoint | `string` | The primary endpoint of the Redis replication group. |
| redis_port | `number` | The redis port. |

## Example use

An example use of the module.

```HCL
module "redis" {
  source = "git::https://github.com/tfemodules/terraform-aws-tfe-redis"

  vpc_id                     = "vpc-xxxxx"
  subnet_ids                 = ["sub-xxxxx", "sub-yyyyy"]
  availability_zones         = ["eu-central-1a", "eu-central-1b"]
  ingress_security_group_ids = ["sg-xxxxxxxxx"]
  redis_auth_token           = "redis-auth-token"
  common_tags = {
    project = "example-redis"
  }
}
```

## Testing

The repository contains tests for the module using kitchen CI.

### Prerequisites

The prerequisites to run the tests are:

* Have Ruby `~> 2.7.2`.
* Have Bundler. Can be installed by running:

  ```bash
  gem install bundler
  ```

* Have the Ruby gems defined in the `Gemfile` installed.

  ```bash
  bundle install
  ```

### Running the test

To run th tests first configure AWS credentials and region.

* `(optional)` Modify the terraform variable values to be used for building the test environment. Can be done by modifying the `test/fixtures/test.tfvars` file.
* Set AWS credentials according to the Terraform AWS provider [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication) e.g. by setting environment variables or aws credentials file.
* Set the AWS region to be used by setting the `AWS_DEFAULT_REGION` environment variable.

To execute the test:

* Converge the test environment

  ```bash
  bundle exec kitchen converge
  ```

  After the environment is converged allow some time (e.g. 1m) for the `cloud-init` on the provisioned test EC2 instance to finish.

* Execute the tests

  ```bash
  bundle exec kitchen verify
  ```

* Cleanup the test environment

  ```bash
  bundle exec kitchen destroy
  ```
