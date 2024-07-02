# 使用的镜像名称和版本标签
REGISTRY ?= docker.io
REPO ?= yearning
IMAGE_NAME = $(REGISTRY)/$(REPO)
IMAGE_TAG ?= latest

# Docker守护进程
DOCKER := docker

# 构建Docker镜像
build:
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) . -f docker/Dockerfile_oss

# 推送Docker镜像
push: build
	$(DOCKER) push $(IMAGE_NAME):$(IMAGE_TAG)

# 运行Docker容器
run:
	$(DOCKER) run -d --name $(IMAGE_NAME)-container $(IMAGE_NAME):$(IMAGE_TAG)

# 停止并删除容器
stop-remove:
	$(DOCKER) stop $(IMAGE_NAME)-container || true
	$(DOCKER) rm $(IMAGE_NAME)-container || true

# 删除镜像
image-rm:
	$(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true

# 清理：停止容器并删除容器和镜像
clean: stop-remove image-rm

# 显示容器日志
logs:
	$(DOCKER) logs $(IMAGE_NAME)-container

# 交互式进入容器
shell:
	$(DOCKER) exec -it $(IMAGE_NAME)-container /bin/bash

# 检查镜像是否存在
image-exists:
	$(DOCKER) images $(IMAGE_NAME):$(IMAGE_TAG) > /dev/null ; echo $$?

.PHONY: build run stop-remove image-rm clean logs shell image-exists