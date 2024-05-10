#!/usr/bin/env bash

# ------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------- HEADER --------------------------------------------------- #
## AUTHOR:
### 	Ciro Mota
## NAME:
### 	Pos_Fedora.
## DESCRIPTION:
###			Post installation script developed for Fedora,
### 		based on my use of programs, settings and customizations.
## LICENSE:
###		  GPLv3. <https://github.com/ciro-mota/my-pos-install/blob/main/LICENSE>
## CHANGELOG:
### 		Last Edition 08/05/2024. <https://github.com/ciro-mota/my-pos-install/commits/main>

										### SCRIPT IN EXPERIMENTAL STATE ###

# ------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------- TEST AND EXEC ------------------------------------------------- #

install-systemd-boot() { 
	
	sudo dnf up --refresh -y
	sudo rm /etc/dnf/protected.d/{grub2*,shim*}
	sudo dnf remove -y grubby grub2\* && sudo rm -rf /boot/grub2 && sudo rm -rf /boot/loader
	sudo dnf install -y systemd-boot-unsigned sdubby
	cat /proc/cmdline | cut -d ' ' -f 2- | sudo tee /etc/kernel/cmdline
	sudo bootctl install
	sudo kernel-install add "$(uname -r)" /lib/modules/"$(uname -r)"/vmlinuz
	sudo dnf reinstall kernel-core -y
	echo -e "\e[31;1mYou must restart now for the changes to take effect.\e[m"

}

if [[ $(awk '{print $3}' /etc/fedora-release) =~ ^(39|40)$ ]] ### Check if the distribution is correct.
then
	
	if [[ $(test -d /sys/firmware/efi && echo EFI || echo Legacy) = "EFI" ]] ### Check if the OS is starting with EFI.
	then
		
		if [[ $(sudo bootctl 2>&1 | grep "Product" | awk '{print $2}' >/dev/null) = "systemd-boot" ]] ### Check if the OS is starting with systemd-boot.
		then
			echo -e "\e[32;1mYou are already running systemd-boot.\e[m"
			exit 1
		else
			install-systemd-boot
		fi

	else
		echo -e "\e[31;1mYou are not running on an EFI system.\e[m"
		exit 1
	fi

else
	echo -e "\e[31;1mDistro not approved for use with this script.\e[m"
	exit 1
fi
