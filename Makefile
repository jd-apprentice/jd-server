environment ?= prod

prepare: scafolding

script:
	chmod +x ansible/files/shared/scripts/$(script).sh
	./ansible/files/shared/scripts/$(script).sh

playbook:
	ansible-playbook -i ansible/inventory/hosts ansible/playbooks/$(playbook).yml

scafolding:
	$(MAKE) playbook playbook=scafolding

action:
	cd terraform && terraform $(action) -var-file=config/$(environment).tfvars

## The action one is enough but i'm lazy
tf_init:
	cd terraform && terraform init -var-file=config/$(environment).tfvars

tf_plan:
	cd terraform && terraform plan -var-file=config/$(environment).tfvars

tf_test:
	cd terraform && terraform test -var-file=config/$(environment).tfvars