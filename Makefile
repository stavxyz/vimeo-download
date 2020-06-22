OWNER ?= $(USER)
REPOSITORY ?= vimeodl
IMAGE ?= $(OWNER)/$(REPOSITORY)
REVISION    := $(shell git rev-parse --short --verify HEAD)

# Usage call(drun, <image>, <command>)
define drun
	docker run \
	  --tty \
	  --env HELLO \
	  --volume $(shell pwd):/opt/app/ \
	  --interactive $(1) \
	  $(2)
endef

.PHONY: run
run:
	$(call drun,$(OWNER)/$(REPOSITORY):latest,/bin/bash)

.PHONY: build
build:
	@echo "===> Building $(OWNER)/$(REPOSITORY) image <==="
	docker build \
	  --tag $(OWNER)/$(REPOSITORY):$(REVISION) \
	  --tag $(OWNER)/$(REPOSITORY):latest \
	  --file Dockerfile .

.PHONY:
ls:
	@docker images --no-trunc --format '{{json .}}' | \
		jq -r 'select((.Repository|startswith("$(OWNER)")))' | jq -rs 'sort_by(.Repository)|.[]|"\(.ID)\t\(.Repository):\(.Tag)\t(\(.CreatedSince))\t[\(.Size)]"'
