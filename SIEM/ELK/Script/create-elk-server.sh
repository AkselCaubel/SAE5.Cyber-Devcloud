#!/bin/bash

# Create VM
cd ../Terraform

terraform init
terraform apply


# Provisionning Ansible
cd ../Ansible

ansible-playbook -i inventory elk-provisioning.yml --ask-become-pass

# Create integration

sh ../Script/elk-integration.sh

# Deployment elk agent

ansible-playbook -i goad-inventory elk-agent.yml

