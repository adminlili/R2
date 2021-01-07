.PHONY: greating help install_configure_DB install_nginx_php_pkgs \
 install_ssl_tls_nginx_php cls_lemp_srvs

#.DEFAULT: help

# Target 'all' can call as many targets as needed.
all: greating install_configure_DB install_nginx_php_pkgs \
 install_ssl_tls_nginx_php

greating:
	@echo -e "\n*********** \
	 Hello! This Makefile is for auto installing nginx and php(different versions) \
     services and basic packages for web-server on Centos7/8. \
	 **********\n"
	@echo -e "\n"

# ******************************************************************************
help:
	@echo -e "\n"
	@echo -e "install_configure_DB -------STEP 1-- Install_config MariaDB/Mysql service (including AUTO secure_installation) on host."
	@echo -e "install_nginx_php_pkgs -----STEP 2-- Install_config basic web-server packages services on CentOS 7/8"
	@echo -e "install_ssl_tls_nginx_php --STEP 3-- Install_config NGINX+PHP-FPM+SLL/TLS on CentOS 7/8"
	@echo -e "clean ----------------------STEP 4-- Remove web services from Centos7/8. Clean depended files."
	@echo -e "\n"
	@exit 0
# ******************************************************************************

install_configure_DB:
	@./install_configure_database.sh
	@echo -e "\n"

install_nginx_php_pkgs:
	@./install_php_pkgs_nginx.sh
	@echo -e "\n"

install_ssl_tls_nginx_php:
	@./install_ssl_tls_nginx_php.sh
	@echo -e "\n"

cls_lemp_srvs:
	@./cls_lemp_srvs.sh
	@echo -e "\n*********** \
	 FINISHED: The script cleaned all nginx,php,mysql depended files!\n"
