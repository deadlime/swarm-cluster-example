provider "digitalocean" {
  version = "~> 1.18"
}

locals {
  region = "fra1"
  image = "ubuntu-20-04-x64"
  size = "s-1vcpu-1gb"
}

data "digitalocean_ssh_key" "default" {
  name = "name_of_the_ssh_key"
}

data "digitalocean_domain" "default" {
  name = "example.com"
}

resource "digitalocean_project" "swarm01" {
  name = "swarm01"
  resources = [
    digitalocean_droplet.manager01.urn,
    digitalocean_droplet.worker01.urn,
    digitalocean_droplet.worker02.urn,
  ]
}

resource "digitalocean_vpc" "swarm01" {
  name     = "swarm01"
  region   = local.region
}

resource "digitalocean_record" "manager01" {
  domain = data.digitalocean_domain.default.name
  type   = "A"
  name   = "manager01.swarm01"
  value  = digitalocean_droplet.manager01.ipv4_address
  ttl    = "300"
}

resource "digitalocean_record" "worker01" {
  domain = data.digitalocean_domain.default.name
  type   = "A"
  name   = "worker01.swarm01"
  value  = digitalocean_droplet.worker01.ipv4_address
  ttl    = "300"
}

resource "digitalocean_record" "worker02" {
  domain = data.digitalocean_domain.default.name
  type   = "A"
  name   = "worker02.swarm01"
  value  = digitalocean_droplet.worker02.ipv4_address
  ttl    = "300"
}

resource "digitalocean_record" "traefik" {
  domain = data.digitalocean_domain.default.name
  type   = "CNAME"
  name   = "traefik.swarm01"
  value  = "${digitalocean_record.manager01.fqdn}."
  ttl    = "300"
}

resource "digitalocean_record" "whoami" {
  domain = data.digitalocean_domain.default.name
  type   = "CNAME"
  name   = "whoami.swarm01"
  value  = "${digitalocean_record.manager01.fqdn}."
  ttl    = "300"
}

resource "digitalocean_droplet" "manager01" {
  image = local.image
  name = "manager01.swarm01.example.com"
  region = local.region
  size = local.size
  private_networking = true
  vpc_uuid = digitalocean_vpc.swarm01.id
  ssh_keys = [
    data.digitalocean_ssh_key.default.fingerprint,
  ]
}

resource "digitalocean_droplet" "worker01" {
  image = local.image
  name = "worker01.swarm01.example.com"
  region = local.region
  size = local.size
  private_networking = true
  vpc_uuid = digitalocean_vpc.swarm01.id
  ssh_keys = [
    data.digitalocean_ssh_key.default.fingerprint,
  ]
}

resource "digitalocean_droplet" "worker02" {
  image = local.image
  name = "worker02.swarm01.example.com"
  region = local.region
  size = local.size
  private_networking = true
  vpc_uuid = digitalocean_vpc.swarm01.id
  ssh_keys = [
    data.digitalocean_ssh_key.default.fingerprint,
  ]
}
