prepare: scafolding

playbook:
	ansible-playbook -i ansible/inventory/hosts ansible/playbooks/$(playbook).yml

scafolding:
	$(MAKE) playbook playbook=scafolding