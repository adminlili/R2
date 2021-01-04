.PHONY: greating help change_dnssrvIP install_configure_bind clean

#.DEFAULT: help

# Target 'all' can call as many targets as needed.
all:  greating change_dnssrvIP install_configure_bind

greating:
	@echo -e "\n*********** \
	 Hello! This Makefile is for auto installing bind9 service on Centos7/8. \
	 **********\n"
	@echo -e "\n"

# ******************************************************************************
help:
	@echo -e "\n"
	@echo -e "change_dnssrvIP ---------STEP 1-- Change IP-address for DNS-server on host."
	@echo -e "install_configure_bind --STEP 2-- Install and configure BIND/DNS service on CentOS 7/8"
	@echo -e "clean -------------------STEP 3-- Remove bind9 service from Centos7/8. Clean all depended files."
	@echo -e "\n"
	@exit 0
# ******************************************************************************

change_dnssrvIP:
	@./change_dns_ip.sh
	@echo -e "\n"

install_configure_bind:
	@./install_configure_bind_c8.sh
	@echo -e "\n"

clean:
	@./cls_dns_srvs.sh
	@echo -e "\n*********** \
	 FINISHED: The script cleaned all bind depended files!\n"
