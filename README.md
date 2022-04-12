# docker-azure_cli-mongodb_tools

a simple image based on the azure cli docker image, with mongodb-tools

## Purpose

The purpose of this repository is to automatically update a docker image with custom modifications to the latest version of its dockerfile.
This image is based on mcr.microsoft.com/azure-cli and integrates mongodb-tools in order to easily backup databases in a production aks.

## How does it work?

- Renovate bot checks for the current version of mcr.microsoft.com/azure-cli and creates a pull request if the version is newer than this repository
- on commit to master, the github workflow increases the version number of the container, builds it with the new version, and pushes that image to ghcr.io

## components

Github Actions:

- ./.github/workflows/docker-publish.yml is the github action that will build and publish a new docker image through the makefile and using the latest tag
- ./.github/workflows/versionbump.yml is the github action that will retrieve the latest tag from the repository, remove the "v" prefix, increase the version by a patch number and create a new tag.

Application:

- ./Dockerfile/Dockerfile defines our Docker container
- ./makefile gives us different options to build tag and push our container

Misc:

- ./renovate.json defines the behavior of <https://github.com/renovatebot/renovate>

## Notes

### changes to master should be done in pull requests

This template will deploy a new version on every master push and can therefore create a lot of tagged versions you might not need. To prevent this, changes should only be merged into master through a pull request.

### branch protections

This repository is using a branch protection for master, so only pull request can be deployed. This is a default repository setting but should be activated, to minimize unneeded version bumps, as well as docker images.

This repository also needs at least one approver to merge a pull request. This is also done through default github branch protection.

### skip actions

GitHub Actions: Skip pull request and push workflows with [skip ci]

GitHub Actions supports skipping push and pull_request workflows by looking for some common keywords in your commit message.

If any commit message in your push or the HEAD commit of your PR contains the strings [skip ci], [ci skip], [no ci], [skip actions], or [actions skip] workflows triggered on the push or pull_request events will be skipped.

### Automated Dependency Updates

WhiteSource Renovate keeps source code dependencies up-to-date using automated Pull Requests. It will scan repositories for package manager files (e.g. from npm/Yarn, Bundler, Composer, Go Modules, Pip/Pipenv/Poetry, Maven/Gradle, Dockerfile/k8s, and many more), and submit Pull Requests with updated versions whenever they are found.

see: <https://renovate.whitesourcesoftware.com/>

### dependency on renovate-bot

This repository is using the GitHub App Renovate <https://github.com/apps/renovate>, which means it has access to this repository.
All other actions are run in either github native actions or custom code. This should be taken under advisement in your repository planning.
There are however different version scanners, as well as the premium version of renovate bot which you can run in your private cluster, to avoid your code being in the hands of people you can not control.
