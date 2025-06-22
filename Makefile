environment ?= prod
action ?= init
module ?= base
db_user ?= postgres_user
db_password ?= postgres_password
db_host ?= localhost
db_port ?= 5432

prepare: scafolding

script:
	chmod +x ansible/files/shared/scripts/$(script).sh
	./ansible/files/shared/scripts/$(script).sh

playbook:
	ansible-playbook -i ansible/inventory/hosts ansible/playbooks/$(module)/$(playbook).yml

scafolding:
	$(MAKE) playbook playbook=scafolding

action:
	./terraform/scripts/export_backend.sh $(db_user) $(db_password) $(db_host) $(db_port) terraform_$(module)
	./terraform/scripts/check_backend.sh $(module)
	if [ "$(action)" = "apply" ]; then \
		cd terraform && terraform apply -var-file=config/$(module).tfvars --auto-approve; \
	else \
		cd terraform && terraform $(action) -var-file=config/$(module).tfvars; \
	fi


