# Contributing

A big welcome and thank you for considering contributing to this project!
It is people like you that make it a reality for users in our community.

Reading and following these guidelines will help us make the contribution
process easy and effective for everyone involved. It also communicates that you
agree to respect the time of the developers managing and developing this open
source project. In return, we will reciprocate that respect by addressing your
issue, assessing changes, and helping you finalize your pull requests.

## Table of Contents

* [Code of Conduct](#code-of-conduct)
* [Getting Started](#getting-started)
  * [Issues](#issues)
  * [Pull Requests](#pull-requests)
  * [Workflow](#workflow)
* [Development/Test Environment setup and usage](#developmenttest-environment-setup-and-usage)
  * [First time](#first-time)
  * [Important information about the test environment](#important-information-about-the-test-environment)
  * [Testing](#testing)
* [Code quality tools](#code-quality-tools)
  * [ShellCheck](#shellcheck)
* [CI Information](#ci-information)
* [Documentation updates](#documentation-updates)
* [Getting Help](#getting-help)

## Code of Conduct

We take our open source community seriously and hold ourselves and other
contributors to high standards of communication. By participating and
contributing to this project, you agree to uphold our [Code of Conduct].

## Getting Started

Contributions are made to this repo via [Issues] and [Pull Requests (PRs)].
A few general guidelines that cover both:

- To report security vulnerabilities, please send an email to **andrew.bindner@printon.me**.
- Search for existing Issues and PRs before creating your own.
- We work hard to makes sure issues are handled in a timely manner but,
  depending on the impact, it could take a while to investigate the root cause.
  A friendly ping in the comment thread to the submitter or a contributor can
  help draw attention if your issue is blocking.
- If you have never contributed before, see the [first timer's guide] on the
  Auth0 blog for resources and tips on how to get started.

### Issues

Issues should be used to report problems with the project, request a new
feature, or to discuss potential changes before a PR is created. When you create
a new Issue, a template will be loaded that will guide you through collecting
and providing the information we need to investigate.

If you find an Issue that addresses the problem you are having, please add your
own reproduction information to the existing issue rather than creating a new
one. Adding a [reaction] can also help indicate to our maintainers that a
particular problem is affecting more than just the reporter.

### Pull Requests

PRs to this project are always welcome and can be a quick way to get your fix or
improvement slated for the next release. In general, PRs should:

- Only fix/add the functionality in question **OR** address wide-spread
  whitespace/style issues, not both.
- Add unit or integration tests for fixed or changed functionality (if a test
  suite already exists).
- Address a single concern in the least number of changed lines as possible.
- Include documentation in the appropriate area of the repo.
- Be accompanied by a completed Pull Request template (loaded automatically when
  a PR is created).

For changes that address core functionality or would require breaking changes
(e.g. a major release), it is best to open an Issue to discuss your proposal
first. This is not required but can save time creating and reviewing changes.

### Workflow

In general, we follow the "fork-and-pull-request" Git workflow, which is
summarized below. If this workflow is new to you, we recommend you try out the
[first-contributions practice repo] first!

1. Fork the repository to your own Github account.
2. Clone the forked project to your machine.
3. Ensure the project works on your machine (See [First time] below).
4. Create a branch locally with a succinct but descriptive name.
5. Commit changes to the branch, using [GitHub's keywords] to appropriately link
   commits to related issues, if there are any.
6. Update documentation to reflect your changes.
6. Follow any formatting and testing guidelines specific to this repo (See
   [Code quality tools] and [Testing] below).
7. Push changes to your fork.
8. Open a PR in our repository and follow the PR template so that we can
   efficiently review the changes.


## Development/Test Environment setup and usage

### First time

> [!IMPORTANT]
> _Do the following BEFORE you make any changes, to ensure the project works
as expected on your box. Hit us up in [Discussions] if you have any issues._

1. Install the following development environment dependencies:
   * [Vagrant]
   * [VirtualBox]
   * [VirtualBox Guest Additions] (needed for shared directories between host
     and guest)
   * [ShellCheck]

   On `apt` based systems, AFTER you add the Vagrant apt source, these can all
   be installed with the following command:
   ```bash
   apt-get update && sudo apt-get install vagrant virtualbox virtualbox-guest-additions-iso shellcheck
   ```

2. [Create a fork] of this repository, and clone it to your machine, as
   outlined in the [Workflow] section above.

3. Confirm that you can run linting tests using [`pre-commit.sh`] (_NOTE: If
   [Issue #49] is still open, you can expect to see many failures_). For
   details, see [Code quality tools] below.
   ```bash
   # From the IronJump fork directory:
   ./.github/pre-commit.sh
   ```

4. Confirm the primary test environment is functional:

   a. Change to the desired vagrant OS subdirectory:
      ```bash
      # From the IronJump fork directory:
      cd test/vagrant/ubuntu24
      ```

   b. Start the test VMs (on first run, this step may take some time):
      ```bash
      # From IronJump/test/vagrant/${OS}
      vagrant up
      ```

   c. Check status of the test VMs:
      ```bash
      # From IronJump/test/vagrant/${OS}
      vagrant status
      ```

      Expected output should look something like:
      ```bash
      Current machine states:

      ironjump-ubu2404-server     running (virtualbox)
      ironjump-ubu2404-endpoint-1 running (virtualbox)

      This environment represents multiple VMs. The VMs are all listed
      above with their current state. For more information about a specific
      VM, run `vagrant status NAME`.
      ```

   d. RECOMMENDED: Create a clean snapshot on the test VMs:
      ```bash
      # From IronJump/test/vagrant/${OS}
      vagrant snapshot save clean
      ```

5. Ensure IronJump runs in the primary test environment:

   a. SSH to the server test VM:
      ```bash
      # From IronJump/test/vagrant/${OS}, to access the server
      vagrant ssh
      # OR
      vagrant ssh ironjump-${OS}-server
      ```

   b. Follow the steps in the [README.md#server] section to install IronJump on
      the server test VM.

   c. In a separate terminal window, ssh to the endpoint test VM:
      ```bash
      # From IronJump/test/vagrant/${OS}, to access an endpoint, where N starts at 1
      vagrant ssh ironjump-${OS}-endpoint-${N}
      ```

   d. Follow the steps in the [README.md#endpoint] section to install IronJump
      on the endpoint test VM.

### Important information about the test environment

1. The test environment is built with [Vagrant] and [VirtualBox]. How to use
   these tools is outside of the scope of this guide, but some basic usage will
   be supplied in how it relates to this project. Please refer to the
   documentation for those projects for general usage.
2. When running `vagrant` commands, you must be in a directory containing a
   Vagrantfile. For example, to test with Ubuntu 24.04, you should be in the
   [$PROJECT/test/vagrant/ubuntu24] directory.
3. When using `vagrant ssh MACHINE`, be aware of the following directories in
   the VMs:
   * `/vagrant` - This is a Shared directory which is linked to the top level
     of the project. Changes made to the files in this directory **WILL** be
     reflected outside of the VM!
   * `/opt/IronJump` - This contains COPIES of the files in `/vagrant`. Changes
     made in this directory will **NOT** be reflected outside of the VM unless
     you copy them back to `/vagrant`.
   * The reason `/opt/IronJump` was not made the Shared directory is because
     the `ironjump.role` file is created here, and it is different between
     server and endpoint.
4. If you need more than one endpoint, run `export IRONJUMP_NUM_ENDPOINTS=N`,
   where `N` is the number of endpoints necessary.

### Testing

> [!NOTE]
> _At this time, all testing needs to be completed manually._

If you already had your own environment to work in, feel free to use it. If
not, please use the environment documented above.

1. Test changes as appropriate. Be sure to test related areas which may have
   been affected.

2. Capture screenshots and/or videos demonstrating the working changes.

## Code quality tools

This project contains a [`pre-commit.sh`] script which runs code quality checks
on all project `*.sh` files. Run the following command from your top level
project directory before opening a PR:

```bash
# From the IronJump directory:
./.github/pre-commit.sh
```

> [!TIP]
> _To see all available options, run the script with the `-h` option._

<!--

```bash
# cd $PROJECT_DIR
ln -r -s .github/pre-commit.sh .git/hooks/pre-commit
```

This will result in the script running immediately after executing `git commit` and it will fail to commit any files if this script fails.
-->

### [ShellCheck]

> [!TIP]
> _If [Issue #49] is still open, cleaning up shellcheck failures is a WIP, so
the output may be excessive. HOWEVER, if you are contributing a PR, it is
requested that you execute this script and fix any errors that your changes
introduced. BONUS points for fixing existing errors in the function/areas being
modified. If you make changes to appease ShellCheck, be sure to re-test!_

The [`pre-commit.sh`] script supports specifying the output format for
[ShellCheck] using the `-s SHELLCHECK_FORMAT` argument, where
`SHELLCHECK_FORMAT` is one of `(checkstyle diff gcc json json1 quiet tty)`.
Normal shellcheck default is `tty`, but this script uses the less verbose `gcc`
as default.

## CI Information

The CI process currently runs the [`pre-commit.sh`] script as part of the [lint.yml workflow]. If [Issue #49] is
still open, PRs will not be blocked on this workflow

## Documentation updates

If you notice outdated or missing information, please submit a pull request with
your proposed changes. All types of documentation improvements are welcome, from
fixing typos to updating technical guides.

## Getting Help

Join us in [Discussions] and post your question in the Q&A category!

<!-- Links -->
<!-- Project links (alphabetized) -->
[Code quality tools]:             #code-quality-tools
[Workflow]:                       #workflow
[Code of Conduct]:                ../CODE-OF-CONDUCT.md
[lint.yml workflow]:              ./workflows/lint.yml
[`pre-commit.sh`]:                ./pre-commit.sh
[$PROJECT/test/vagrant/ubuntu24]: ../test/vagrant/ubuntu24
[README.md#endpoint]:             ../README.md#endpoint
[README.md#server]:               ../README.md#server
<!-- Remote links (alphabetized) -->
[Create a fork]:       https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository
[Discussions]:         https://github.com/schlpr0k/IronJump/discussions
[first-contributions practice repo]: https://github.com/firstcontributions/first-contributions
[first timer's guide]: https://auth0.com/blog/a-first-timers-guide-to-an-open-source-project/
[GitHub's keywords]:   https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword
[Issue #49]:           https://github.com/schlpr0k/IronJump/issues/49
[Issues]:              https://github.com/schlpr0k/IronJump/issues
[Pull Requests (PRs)]: https://github.com/schlpr0k/IronJump/pulls
[reaction]:            https://github.com/skills/introduction-to-repository-management/
[ShellCheck]:          https://github.com/koalaman/shellcheck?tab=readme-ov-file#installing
[Vagrant]:             https://developer.hashicorp.com/vagrant/docs/installation
[VirtualBox]:          https://www.virtualbox.org/wiki/Downloads
[VirtualBox Guest Additions]: https://www.virtualbox.org/manual/ch04.html#additions-linuhell
