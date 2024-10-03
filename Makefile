SHELL:=/bin/bash

# Current date
CURRENT_DATE = $(shell date -u +"%Y-%m-%d")

# Machine arch
ARCH = $(shell arch)

# Project name
PROJECT := atarist-toolkit-docker-$(ARCH)

# Version from file
VERSION := $(shell cat version.txt)

# STCMD command from file
STCMD_COMMAND := $(shell cat stcmd.template)

# The docker tag name
DOCKER_TAG_NAME = latest

# Docker account
DOCKER_ACCOUNT = logronoide

# Docker image name
DOCKER_IMAGE_NAME = $(PROJECT)

# Docker Hub credentials
DOCKER_USERNAME = ${DOCKERHUB_USERNAME}
DOCKER_PASSWORD = ${DOCKERHUB_PASSWORD}

## Run ci part
.PHONY: all
all: clean build publish

# Create the install files ready for release
.PHONY: release
release:
	sed "s&STCMD_COMMAND&$(STCMD_COMMAND)&g" install/linux.sh.template > install/linux.sh.tmp
	sed 's/*/\\$$/g' install/linux.sh.tmp | sed 's/^[[:space:]]//' > install/install_atarist_toolkit_docker.sh
	rm install/linux.sh.tmp
	mkdir -p target/release/
	cp install/install_atarist_toolkit_docker.sh target/release/

## Clean docker image
.PHONY: clean
clean:
	-docker rmi $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE_NAME):$(VERSION)
	-docker rmi $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE_NAME):latest

## Build docker image
.PHONY: build
build:
	docker build -f Dockerfile -t $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG_NAME) .

## Tag docker images
.PHONY: tag-images
tag-images:
	docker tag "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:$(DOCKER_TAG_NAME)" "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:${VERSION}"
	docker tag "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:$(DOCKER_TAG_NAME)" "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:${VERSION}-${CURRENT_DATE}"

## Publish docker image
.PHONY: publish
publish: build tag-images
	echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
	docker push "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:$(DOCKER_TAG_NAME)"
	docker push "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:${VERSION}"
	docker push "${DOCKER_ACCOUNT}/${DOCKER_IMAGE_NAME}:${VERSION}-${CURRENT_DATE}"

## Tag this version
.PHONY: tag
tag:
	-git tag -d latest && git push origin --delete latest
	git tag latest && git push origin latest && \
	git tag v$(VERSION) && git push origin v$(VERSION) && \
	echo "Tagged: $(VERSION)"
