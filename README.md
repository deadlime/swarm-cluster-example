# Swarm cluster example

An example to how to create a Docker Swarm cluster on DigitalOcean with Terraform and Ansible. Routing, service discovery and TLS certificate issuance is done by Traefik.

## Creating the infrastructure

```
$ cd terraform/
$ read -s DIGITALOCEAN_ACCESS_TOKEN
$ export DIGITALOCEAN_ACCESS_TOKEN
$ terraform init
$ terraform apply
$ unset DIGITALOCEAN_ACCESS_TOKEN
```

## Setting up Docker Swarm

```
$ cd ansible/
$ ansible-playbook setup.yml
```

## Deploying services

```
$ cd ansible/
$ ansible-playbook --ask-vault-pass deploy.yml
```

The Ansible Vault password is `test`. The basic auth for Traefik dashboard is `test:test`.
