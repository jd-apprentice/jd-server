environment ?= prod

prepare: scafolding

script:
	chmod +x ansible/files/shared/scripts/$(script).sh
	./ansible/files/shared/scripts/$(script).sh

playbook:
	ansible-playbook -i ansible/inventory/hosts ansible/playbooks/$(playbook).yml

scafolding:
	$(MAKE) playbook playbook=scafolding

init:
	cd terraform && terraform init -var-file=config/$(environment).tfvars

action:
	cd terraform && terraform $(action) -var-file=config/$(environment).tfvars -compact-warnings