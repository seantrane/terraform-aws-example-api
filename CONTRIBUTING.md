# Contributing

> Thank you for contributing. Contributions are always welcome, no matter how large or small.

## Table of Contents

- [Guidelines](#guidelines)
- [Pull Requests](#pull-requests)
- [Clone the Repository](#clone-repo)
- [Install Dependencies](#install-dependencies)
- [File Structure](#file-structure)

---

## Guidelines <a id="guidelines"></a>

As a contributor, here are the guidelines you should follow:

- [Code of conduct](https://github.com/seantrane/terraform-aws-example-api/blob/master/CODE_OF_CONDUCT.md)
- [How can I contribute?](https://github.com/seantrane/terraform-aws-example-api/blob/master/CONTRIBUTING.md#how-can-i-contribute)
- [Using the issue tracker](https://github.com/seantrane/terraform-aws-example-api/blob/master/CONTRIBUTING.md#using-the-issue-tracker)
- [Submitting a Pull Request](https://github.com/seantrane/terraform-aws-example-api/blob/master/CONTRIBUTING.md#submitting-a-pull-request)
- [Coding rules](https://github.com/seantrane/terraform-aws-example-api/blob/master/CONTRIBUTING.md#coding-rules)
- [Working with code](https://github.com/seantrane/terraform-aws-example-api/blob/master/CONTRIBUTING.md#working-with-code)

We also recommend to read [How to Contribute to Open Source](https://opensource.guide/how-to-contribute).

---

## Pull Requests <a id="pull-requests"></a>

Thank you for contributing.

- Create your branch from `master`.
- Ensure your [git commit messages follow the required format](https://github.com/seantrane/terraform-aws-example-api/blob/master/STYLE_GUIDES.md#git-commit-messages).
- Ensure your scripts are well-formed, well-documented and object-oriented.
- Ensure your scripts are stateless and can be reused by all.
- Update your branch, and resolve any conflicts, before making pull request.
- Fill in [the required template](https://github.com/seantrane/terraform-aws-example-api/blob/master/.github/PULL_REQUEST_TEMPLATE.md).
- Do not include issue numbers in the PR title.
- Include screenshots and animated GIFs in your pull request whenever possible.
- Follow the [style guide](https://github.com/seantrane/terraform-aws-example-api/blob/master/STYLE_GUIDES.md) [applicable to the language](https://github.com/seantrane/terraform-aws-example-api/blob/master/STYLE_GUIDES.md#languages) or task.
- Include thoughtfully-worded, well-structured tests/specs. See the [Tests/Specs Style Guide](https://github.com/seantrane/terraform-aws-example-api/blob/master/STYLE_GUIDES.md#tests).
- Document new code based on the [Documentation Style Guide](https://github.com/seantrane/terraform-aws-example-api/blob/master/STYLE_GUIDES.md#documentation).
- End all files with a newline.

---

## Clone the Repository <a id="clone-repo"></a>

```bash
git clone https://github.com/seantrane/terraform-aws-example-api.git terraform-aws-example-api && cd terraform-aws-example-api
```

## Install Dependencies <a id="install-dependencies"></a>

You need to install `npm`, `docker`, `aws` and `terraform` as global dependencies

```sh
# Install repo/app dependencies
./cli -i
```

## CLI

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

## File Structure <a id="file-structure"></a>

```text
terraform-aws-example-api/
├─ .dependabot/                                  * Dependabot config
├─ .github/                                      * GitHub config files and templates
│
├─ scripts/                                      * shell scripts directory
│  └─ functions.sh                               * common/shared shell functions
│
├─ src/                                          * the source code directory
│
├─ temp/                                         * temp directory for builds and e2e tests
│
├─ terraform/                                    * the infrastructure-as-code directory
│  ├─ <env>/                                     * <env> based infrastructure
│  │  ├─ locals.tf ~> ../locals.tf               * symlink to primary locals.tf file
│  │  ├─ main.tf ~> ../main.tf                   * symlink to primary main.tf file
│  │  ├─ providers.tf ~> ../providers.tf         * symlink to primary providers.tf file
│  │  ├─ terraform.auto.tfvars                   * env-based override of primary terraform.tfvars file
│  │  ├─ terraform.tfstate                       * env-based Terraform-state (controlled by CI/CD)
│  │  ├─ terraform.tfstate.backup                * env-based Terraform-state backup (controlled by CI/CD)
│  │  ├─ terraform.tfvars ~> ../terraform.tfvars * symlink to primary terraform.tfvars file
│  │  └─ variables.tf ~> ../variables.tf         * symlink to primary variables.tf file
│  │
│  ├─ locals.tf                                  * symlink to primary locals.tf file
│  ├─ main.tf                                    * symlink to primary main.tf file
│  ├─ providers.tf                               * symlink to primary providers.tf file
│  ├─ terraform.tfvars                           * symlink to primary terraform.tfvars file
│  └─ variables.tf                               * symlink to primary variables.tf file
│
├─ .editorconfig                                 * IDE config file
├─ .env.example                                  * example config file for required env-variables
├─ .markdownlint.yaml                            * Markdown lint rules and config
├─ .travis.yml                                   * CI/CD config file
├─ CODE_OF_CONDUCT.md                            * contributor code-of-conduct policy
├─ CODEOWNERS                                    * default code-reviewers for pull-requests
├─ CONTRIBUTING.md                               * contribution guidelines
├─ CHANGLOG.md                                   * changelog autogenerated by `@semantic-release/changelog`
├─ cli                                           * command-line interface for repository tasks
├─ docker-compose.yml                            * Docker-compose config file
├─ LICENSE                                       * software license file
├─ mocha.opts                                    * mocha config
├─ openapi.yaml                                  * API Specifications: OpenAPI v3
├─ package-lock.json                             * npm package dependency lock file
├─ package.json                                  * npm package config
├─ README.md                                     * repository readme
├─ ROADMAP.md                                    * repository roadmap
├─ sonar-project.properties                      * SonarCloud config
├─ STYLE_GUIDES.md                               * Style guides, standards and practices
├─ swagger.yaml                                  * API Specifications: Swagger v2
├─ tsconfig.json                                 * TypeScript config
├─ tslint.json                                   * TSLint config
└─ typedoc.json                                  * TypeDoc config
```

---

#### Happy coding!
