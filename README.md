# REGARDS docker swarm deployment

## Introduction

This document introduce how to deploy a REGARDS stack thanks to ansible on a docker swarm environment.  
All REGARDS docker images are available on our github repository at : `https://github.com/orgs/RegardsOss/packages?repo_name=regards-deployment` or our docker images registry : `docker.pkg.github.com/regardsoss/regards-deployment`.

## Pre-requisites

This repository contains Ansible playbooks and roles necessary to configure and deploy
REGARDS on a Docker Swarm cluster.

Install Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

## Deploy demo

The demo inventory is preconfigured to deploy REGARDS stack on one docker node.
You need to edit the `inventories/demo/group_vars/all/main.yml` to configure installation.

When configuration is done run :
```shell
ansible-playbook -i inventories/demo setup-vm.yml --ask-become-pass
ansible-playbook -i inventories/demo regards.yml --ask-become-pass
```

## Deploy multihosts

The multihosts inventory is preconfigured to deploy regards stack on multiple nodes.
You need to edit the `inventories/multihosts/group_vars/all/main.yml` and `inventories/multihosts/hosts` to configure installation.
In `inventories/multihosts/hosts` edit access to nodes regards-master and regards-slave for :
 - ansible_host : host name of the server
 - ansible_user : user login to log on by ssh to configure & install
 - ansible_password : user password to log on by ssh to configure & install

**NOTE** : In multi nodes deployment mode the `global_stack.workdir` variable have to be the same accessible directory on each nodes as a NFS mount.

When configuration is done run :
```shell
ansible-playbook -i inventories/multihosts setup-vm.yml --ask-become-pass
ansible-playbook -i inventories/multihosts regards.yml --ask-become-pass
```

## Ansible tasks

### Introduction

If users are not in sudoers you can add `--ask-become-pass` option to an ansible-playbook command to become superuser when required.

### setup-vm.yml

This ansible task install & configure docker swarm environement on each nodes configured in your inventory `hosts` file.

```shell
ansible-playbook -i inventories/demo setup-vm.yml
```

### regards.yml

This ansible task install & configure & run REGARDS on each nodes configured in your inventory `hosts` file.


```shell
ansible-playbook -i inventories/demo regards.yml
```

### regards-config.yml

This ansible task update REGARDS deployed stack that refers to the provided inventory.

```shell
ansible-playbook -i inventories/demo regards-config.yml
```

### regards-shutdown.yml

This ansible task shutdown REGARDS deployed stack that refers to the provided inventory.

```shell
ansible-playbook -i inventories/demo regards-shutdown.yml
```

### regards-delete.yml

This ansible task delete REGARDS deployed stack that refers to the provided inventory.

```shell
ansible-playbook -i inventories/demo regards-delete.yml
```
