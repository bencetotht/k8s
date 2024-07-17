terraform {
  required_providers {
    docker = {
        source: "kreuzwerker/docker"
        version: "2.25.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
    name = "nginx:latest"
}

resource "docker_container" "nginx_container" {   
    name = "random_nginx_container"
    image = docker_image.nginx.image_id
    ports {
        internal = 8000
        external = 8000
    }
}