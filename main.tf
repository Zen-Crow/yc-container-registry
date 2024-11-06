### Data Sources ###
data "yandex_client_config" "client" {}

### Locals variables ###
locals {
  folder_id         = data.yandex_client_config.client.folder_id
  registry_name     = "yc-registry-hub"
  repo_name         = "yc-docker-repo"
  docker_image_name = "image-name"
  tag               = "latest"
}

################
### Registry ###
################
resource "yandex_container_registry" "this" {
  folder_id = local.folder_id
  name      = local.registry_name
}

### Registry Iam Binding ###
resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = yandex_container_registry.this.id
  role        = "container-registry.images.puller"

  members = [
    "system:allUsers",
  ]
}

##################
### Repository ###
##################
resource "yandex_container_repository" "this" {
  name = "${yandex_container_registry.this.id}/${local.repo_name}"
}

### Repository Iam Binding ###
resource "yandex_container_repository_iam_binding" "pusher" {
  repository_id = yandex_container_repository.this.id
  role          = "container-registry.images.pusher"

  members = [
    "system:allUsers",
  ]
}

### Repository Lifecycle Policy ###
resource "yandex_container_repository_lifecycle_policy" "this" {
  name          = "lifecycle-policy"
  status        = "active" 
  repository_id = yandex_container_repository.this.id

  rule {
    description   = "Политика удаления образов"
    untagged      = true
    tag_regexp    = ".*"
    retained_top  = 1
    expire_period = "48h"
  }
}

### Pause after resource creation ###
resource "time_sleep" "wait_for_resources" {
  create_duration = "10s"

  depends_on = [
    yandex_container_registry.this,
    yandex_container_repository.this,
    yandex_container_repository_lifecycle_policy.this,
    yandex_container_registry_iam_binding.puller,
    yandex_container_repository_iam_binding.pusher
  ]
}

### Build Docker Image ###
resource "null_resource" "docker_image_build" {

  # Checksum of Dockerfile
  triggers = {
    dockerfile_hash = sha256(file("./config-app/Dockerfile"))
  }

  provisioner "local-exec" {
    command = <<EOT
      docker build --no-cache -f ./config-app/Dockerfile -t cr.yandex/${yandex_container_registry.this.id}/${local.docker_image_name}:${local.tag} ./config-app
    EOT
  }

  depends_on = [
    yandex_container_repository_iam_binding.pusher,
    yandex_container_registry_iam_binding.puller
  ]
}

### Push Docker Image ###
resource "null_resource" "docker_push" {

  # Checksum of Dockerfile
  triggers = {
    dockerfile_hash = sha256(file("./config-app/Dockerfile")) 
  }

  provisioner "local-exec" {
    command = <<EOT
      docker push cr.yandex/${yandex_container_registry.this.id}/${local.docker_image_name}:${local.tag}
    EOT
  }

  depends_on = [
    null_resource.docker_image_build
  ]
}
