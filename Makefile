environment ?= prod
action ?= init
module ?= base

prepare: scafolding

script:
	chmod +x ansible/files/shared/scripts/$(script).sh
	./ansible/files/shared/scripts/$(script).sh

playbook:
	ansible-playbook -i ansible/inventory/hosts ansible/playbooks/$(module)/$(playbook).yml

scafolding:
	$(MAKE) playbook playbook=scafolding

action:
	if [ "$(action)" = "apply" ]; then \
		cd terraform && terraform apply -var-file=config/$(module).tfvars --auto-approve; \
	else \
		cd terraform && terraform $(action) -var-file=config/$(module).tfvars; \
	fi


