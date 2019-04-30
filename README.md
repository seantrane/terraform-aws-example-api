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
