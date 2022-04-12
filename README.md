# docker-azure_cli-mongodb_tools

a simple image based on the azure cli docker image, with mongodb-tools

## Purpose

The purpose of this repository is to automatically update a docker image with custom modifications to the latest version of its dockerfile.
This image is based on mcr.microsoft.com/azure-cli and integrates mongodb-tools in order to easily backup databases in a production aks.

## How does it work?

- Renovate bot checks for the current version of mcr.microsoft.com/azure-cli and creates a pull request if the version is newer than this repository
- on commit to master, the github workflow increases the version number of the container, builds it with the new version, and pushes that image to ghcr.io

## components

- ./Dockerfile/Dockerfile defines our workflow
- ./makefile gives us different options to build tag and push our container
- ./renovate.json defines the behavior of <https://github.com/renovatebot/renovate>

## Notes

GitHub Actions: Skip pull request and push workflows with [skip ci]

GitHub Actions supports skipping push and pull_request workflows by looking for some common keywords in your commit message.

If any commit message in your push or the HEAD commit of your PR contains the strings [skip ci], [ci skip], [no ci], [skip actions], or [actions skip] workflows triggered on the push or pull_request events will be skipped.