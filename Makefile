# VERSION defines the project version for the bundle.
# Update this value when you upgrade the version of your project.
VERSION ?= $(shell git describe --abbrev=0  --tags $(git rev-list --tags --max-count=1))
# this uses automated versioning by tags
#VERSION=$(shell git describe --tags $(git rev-list --tags --max-count=1))
#PATH = $(shell basename "`pwd`")
NAME=azure_cli-mongodb_tools
GITBASEURL = github.com/jhoelzel
CONTAINER_REPOSITORY=ghcr.io
## Accountname ends in / because there are none on some registrys
CONTAINER_REPOSITORY_ACCOUNTNAME=jhoelzel/
PROJECTNAME = $(addprefix ${GITBASEURL}/,${NAME})
IMAGE_NAME=${NAME}:${VERSION}
IMAGE_NAME_LATEST=${NAME}:latest
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

# Setting SHELL to bash allows bash commands to be executed by recipes.

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

all: build

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

commithistory: ## create the commithistory in a nice format
	 git log --reverse > CommitHistory.txt

##@ Build

build: ## Build the docker image and tag it with the current version and :latest
	docker build -t ${CONTAINER_REPOSITORY}/${CONTAINER_REPOSITORY_ACCOUNTNAME}${IMAGE_NAME} -t  ${CONTAINER_REPOSITORY}/${CONTAINER_REPOSITORY_ACCOUNTNAME}${IMAGE_NAME_LATEST}  . -f ./Dockerfile/Dockerfile

docker-run: build ## Build the docker image and tag it and run it in docker
	docker stop $(IMAGE_NAME) || true && docker rm $(IMAGE_NAME) || true
	docker run --name ${NAME} --rm \
		$(IMAGE_NAME)

docker-push: ##push your image to the docker hub
	docker push  ${CONTAINER_REPOSITORY}/${CONTAINER_REPOSITORY_ACCOUNTNAME}${IMAGE_NAME}
	docker push  ${CONTAINER_REPOSITORY}/${CONTAINER_REPOSITORY_ACCOUNTNAME}${IMAGE_NAME_LATEST}



