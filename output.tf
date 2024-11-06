output "warning_before_destroy_resource" {
  value = "yc container image delete $(yc container image list --format json | jq -r '.[].id')"
}

output "cr_registry_name" {
  value = "cr.yandex/${yandex_container_registry.this.id}/${local.docker_image_name}:${local.tag}"
}