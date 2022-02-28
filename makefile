SHELL := /bin/bash

run:
	go run main.go

#=======================================================================================================================
# Building containers

VERSION := 1.0

all: service

service:
	docker build \
	-f zarf/docker/dockerfile \
	-t service-amd64:$(VERSION) \
	--build-arg BUILD_REF=$(VERSION) \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	.

#=======================================================================================================================
# Runing from within k8s/kind

KIND_CLUSTER := jonasoft-cluster

kind-up:
	kind create cluster \
		--image kindest/node:v1.21.1@sha256:fae9a58f17f18f06aeac9772ca8b5ac680ebbed985e266f711d936e91d113bad \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yaml

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide



#