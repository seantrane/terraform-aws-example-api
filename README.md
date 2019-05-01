# terraform-aws-example-api

> An example API deployed on AWS using Terraform.

## Table of Contents

- [About](#about)
- [Usage](#usage)
- [Support](#support)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

---

## About the App <a id="about"></a>

This repository is a starter kit, template and proof-of-concept for managing API development that is deployed on AWS using Terraform.

The primary goal is to exemplify a complete SDLC approach to API development in a real-world scenario.
The secondary goal is to ensure infrastructure-as-code is fully integrated in repo/app management and workflows.
There is also a huge focus on automation and implementing all the best CI/CD practices possible.

### Features

- CLI to encapsulate all repository tasks/scripting
- Automated SEMVER
- OAS/Swagger API design and development
- TypeScript-based JavaScript development
- Node.js/Express-based API
- Static analysis for; Shell, Markdown, TypeScript files
- Mocha/Sinon/Istanbul testing and code coverage
- SonarCloud analysis/reporting
- Travis CI support
- Docker-based application
- Container-based infrastructure
- Terraform infrastructure-as-code
- AWS Elastic Beanstalk application

## Usage <a id="usage"></a>

You need to install `npm`, `docker`, `aws` and `terraform` as global dependencies, in order to run `./cli`.

Then, if required, make a copy of `.env.example` called `.env` and fill in required environment variables (for CI/CD).

```sh
# Install
./cli --install
# Run app locally
./cli --start
```

### CLI

```sh
# Use 'env' argument, when necessary, to set environment/stage:
--env=dev

# Get help for 'cli' command
./cli --help

# Install dependencies:
./cli --install
# or
./cli -i

# Run static/dynamic analysis/tests:
./cli --test --env=dev
# or
./cli -t --env=dev

# Publish release:
./cli --publish
# or
./cli -p

# Create/update infrastructure and deploy:
./cli --deploy --env=dev
# or
./cli -d --env=dev

# Full CI/CD flow:
./cli --install --test --publish --deploy --env=dev
# or
./cli -i -t -p -d --env=dev

# Destroy infrastructure:
./cli --destroy --env=dev
```

### CI/CD, Infrastructure and Deployment

When running the `./cli --deploy --env=dev` command, the script will create infrastructure in the AWS account, using credentials and region variables provided in `.env` files (when running locally) - or as environment variables when running as an automated CI task.

The `TF_VAR_namespace` variable in `.env` file will be used as a prefix in the naming convention applied to all AWS resources that get created. The resource naming convention prefix will appear as `<namespace>-<env>-<keyname>-...`, with `keyname` being set in the `config.meta.keyname` property of `package.json` file.

The infrastructure-as-code will perform the following primary tasks, in order:

1. Create ECR, _for Docker images storage_
2. Create Container Definitions, _for ECS config_
3. Create S3 Bucket, _for Container Definitions storage_
4. Create VPC
5. Create Subnets
6. Create Beanstalk Application
7. _Compress Container Definitions_
8. _Upload Container Definitions zip file to S3_
9. Create Beanstalk Application Version, _using Container Definitions file_
10. Create Beanstalk Application Environment
11. Deploy Beanstalk Application Version, _to Beanstalk Application Environment_

The IAC takes advantage of [Terraform](https://www.terraform.io/) and [Terraform Modules provided by CloudPosse](https://docs.cloudposse.com/). Each module used in the IAC will create various other interdependent resources, such as; IAM resources, Autoscaling Groups, Security Groups, etc. These are intentionally not listed above to keep focus on the primary modules/resources being created.

The `./cli --destroy --env=dev` command will delete all artifacts (S3 objects, images, etc.) and then destroy all resources in reverse of the order created.

---

## Support <a id="support"></a>

[Submit an issue](https://github.com/seantrane/terraform-aws-example-api/issues/new), in which you should provide as much detail as necessary for your issue.

## Contributing <a id="contributing"></a>

Contributions are always appreciated. Read [CONTRIBUTING.md](https://github.com/seantrane/terraform-aws-example-api/blob/master/CONTRIBUTING.md) documentation to learn more.

## Changelog <a id="changelog"></a>

Release details are documented in the [CHANGELOG.md](https://github.com/seantrane/terraform-aws-example-api/blob/master/CHANGELOG.md) file, and on the [GitHub Releases page](https://github.com/seantrane/terraform-aws-example-api/releases).

---

## License <a id="license"></a>

[ISC License](https://github.com/seantrane/terraform-aws-example-api/blob/master/LICENSE)

Copyright (c) 2019 [@seantrane](https://github.com/seantrane)
