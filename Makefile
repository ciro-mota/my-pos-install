# ------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------- HEADER --------------------------------------------------- #
## AUTHOR:
### 	Ciro Mota
## NAME:
### 	Makefile.
## DESCRIPTION:
###			Post installation script developed for Fedora.
### 		Based on my use of programs, settings and customizations.
## LICENSE:
###		  GPLv3. <https://github.com/ciro-mota/my-pos-install/blob/main/LICENSE>
## CHANGELOG:
### 		Last Edition 20/05/2024. <https://github.com/ciro-mota/my-pos-install/commits/main>

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ VARIABLES AND REQUIREMENTS --------------------------------------- #
### Commom variables.
MAKEFLAGS += --no-print-directory
FEDORA_RELEASE = $(shell head /etc/fedora-release | sed 's/.* \([0-9]\+\) .*/\1/')
.SHELLFLAGS = -ec

### Dynamic repos and download links.
url_flathub = https://flathub.org/repo/flathub.flatpakrepo
url_tviewer = https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
url_jopplin = https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh
url_fastfetch = https://github.com/ciro-mota/my-pos-install/raw/main/confs/fastfetch/config.jsonc
url_terminator = https://github.com/ciro-mota/my-pos-install/raw/main/confs/terminator/config
url_micro = https://github.com/ciro-mota/my-pos-install/raw/main/confs/micro/settings.json
url_starship = https://github.com/ciro-mota/my-pos-install/raw/main/confs/starship/starship.toml
url_vim = https://github.com/ciro-mota/my-pos-install/raw/main/confs/vim/.vimrc
url_nano = https://github.com/ciro-mota/my-pos-install/raw/main/confs/nano/.nanorc
url_zsh_aliases = https://github.com/ciro-mota/my-pos-install/raw/main/confs/zsh/.zsh_aliases
url_ulauncher = https://github.com/ciro-mota/my-pos-install/raw/main/confs/ulauncher/transparent-adwaita.zip
url_fantasque = https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FantasqueSansMono/Regular/FantasqueSansMNerdFontMono-Regular.ttf

### Installation and uninstallation packages.
apps_remover = cheese \
	gnome-abrt \
	gnome-boxes \
	gnome-clocks \
	gnome-connections \
	gnome-contacts \
	gnome-maps \
	gnome-software \
	gnome-text-editor \
	gnome-tour \
	libreoffice-* \
	mediawriter \
	nvidia-gpu-firmware \
	PackageKit \
	totem \
	rhythmbox \
	virtualbox-guest-additions-* \
	yelp

apps = android-tools \
	bat \
	btop \
	cabextract \
	chromium \
	containerd \
	codium \
	cowsay \
	fastfetch \
	ffmpegthumbnailer \
	file-roller \
	flameshot \
	fortune-mod \
	gedit \
	gimp \
	gnome-tweaks \
	goverlay \
	heroic-games-launcher-bin \
	hugo \
	ksnip \
	lolcat \
	lsd \
	mangohud \
	micro \
	opentofu \
	qbittorrent \
	qemu-system-x86 \
	terminator \
	steam \
	ulauncher \
	unrar-free \
	vim-enhanced \
	vlc \
	vlc-plugins-freeworld \
	xorg-x11-font-utils \
	zsh

flatpaks = com.github.finefindus.eyedropper \
	com.github.GradienceTeam.Gradience \
	com.mattjakeman.ExtensionManager \
	org.libreoffice.LibreOffice \
	org.remmina.Remmina \
	org.telegram.desktop

code_extensions = AquaSecurityOfficial.trivy-vulnerability-scanner \
	dendron.dendron-markdown-shortcuts \
	eamodio.gitlens \
	emmanuelbeziat.vscode-great-icons \
	foxundermoon.shell-format \
	HashiCorp.terraform \
	ritwickdey.LiveServer \
	Shan.code-settings-sync \
	streetsidesoftware.code-spell-checker \
	streetsidesoftware.code-spell-checker-portuguese-brazilian \
	timonwong.shellcheck \
	zhuangtongfa.Material-theme

directory_downloads = $(HOME)/Downloads/apps

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ APPLYING REQUIREMENTS -------------------------------------------- #
dnf-tweaks:									# Apply Tweaks to dnf.conf
	@sudo echo -e "color=always" | sudo tee -a /etc/dnf/dnf.conf
	@sudo echo -e "clean_requirements_on_remove=True" | sudo tee -a /etc/dnf/dnf.conf
	@sudo echo -e "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

app-remover:								# Uninstalling unnecessary packages.
	@sudo dnf remove -y $(apps_remover)

add-rpm-fusion:								# Adding RPM Fusion.
	@sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(shell rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(shell rpm -E %fedora).noarch.rpm -y

.ONESHELL:
add-vscodium-repo:							# Adding VSCodium repo.
	@sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
	[gitlab.com_paulcarroty_vscodium_repo]
	name=gitlab.com_paulcarroty_vscodium_repo
	baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
	metadata_expire=1h
	EOF

add-heroic-repo:							# Adding Heroic Games repo.
	@sudo dnf copr enable atim/heroic-games-launcher -y

add-flathub:								# Adding Flathub repo.
	@flatpak remote-add --if-not-exists flathub $(url_flathub)

update-repos:								# Updating system after adding new repos.
	@sudo dnf upgrade --refresh -y

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUTION ------------------------------------------------- #
app-install:								# Install of apps list.
	@sudo dnf install -y $(apps)

add-multimedia:								# Enabling multimedia support and install.
	@sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel -y
	@sudo dnf install lame\* --exclude=lame-devel -y
	@sudo dnf group upgrade --with-optional Multimedia -y
	@sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
	
install-amd-mesa:							# Install Mesa AMD components from rpmfusion.
	@sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
	@sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
	@sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
	@sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y

install-qemu:								# Installing QEMU/Virt-Manager.
	@sudo dnf install @virtualization -y

install-flatpaks:							# Install of Flatpak apps.
	@sudo flatpak install flathub -y $(flatpaks)

install-joplin:								# Install of Jopplin.
	@wget -O - $(url_jopplin) | bash

install-rpm:								# Downloading and installing .rpm packages.
	@mkdir -p $(directory_downloads)
	@curl -fsSL $(url_tviewer) -o $(directory_downloads)/teamviewer.rpm
	@sudo dnf install -y $(directory_downloads)/teamviewer.rpm

install-codium-ex:							# Install of Codium extensions.
	@for code_ext in $(code_extensions); do \
		codium --install-extension $$code_ext 2> /dev/null; \
	done

install-tinifier:							# Install Tinifier compress images tool.
	@wget -O /tmp/tinifier https://github.com/tarampampam/tinifier/releases/download/v4.1.0/tinifier-linux-amd64
	@sudo cp /tmp/tinifier /usr/local/bin
	@sudo chmod +x /usr/local/bin/tinifier
	
install-lact:								# Install LACT AMD GPU Tool.
	@curl -fsSL https://api.github.com/repos/ilya-zlobintsev/LACT/releases/latest \
	| grep "browser_download_url.*fedora-40.rpm" \
	| cut -d : -f 2,3 \
	| tail -1 \
	| tr -d \" \
	| xargs wget -q -P /tmp/ \
	&& sudo dnf install -y /tmp/*fedora-40.rpm

install-ms-fonts:							# Installing Microsoft Fonts:
	@yes | sudo rpm -i -y https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

# # ------------------------------------------------------------------------------------------------------------- #
# # -------------------------------------------------- POST-INSTALL --------------------------------------------- #
## wiki.archlinux.org/title/improving_performance#Changing_I/O_scheduler
.ONESHELL:
apply-performance:							# Apply performance disk improvements.
	@sudo tee -a /etc/udev/rules.d/60-ioschedulers.rules << 'EOF'
	# HDD
	ACTION=="add|change", KERNEL=="sdb", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

	# SSD
	ACTION=="add|change", KERNEL=="sda", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
	EOF

## wiki.manjaro.org/index.php/Improve_Font_Rendering
## discussion.fedoraproject.org/t/fonts-in-gtk-4-apps-look-different-more-blurry/66778
.ONESHELL:
apply-font-fix:								# Apply font fixes.
	@if [ -d "$(HOME).config/gtk-4.0" ]; then \
		echo -e "gtk-hint-font-metrics=1" | tee -a $(HOME)/.config/gtk-4.0/settings.ini
	else \
		mkdir -p $(HOME)/.config/gtk-4.0
		echo -e "gtk-hint-font-metrics=1" | tee -a $(HOME)/.config/gtk-4.0/settings.ini
	fi

	@if [ -d "$(HOME)/.config/fontconfig" ]; then \
		tee -a $(HOME)/.config/fontconfig/fonts.conf << 'EOF'
		<?xml version="1.0"?>
		<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
		<fontconfig>
		<match target="font">
			<edit name="antialias" mode="assign">
			<bool>true</bool>
			</edit>
			<edit name="hinting" mode="assign">
			<bool>true</bool>
			</edit>
			<edit mode="assign" name="rgba">
			<const>rgb</const>
			</edit>
			<edit mode="assign" name="hintstyle">
			<const>hintslight</const>
			</edit>
			<edit mode="assign" name="lcdfilter">
			<const>lcddefault</const>
			</edit>
		</match>
		</fontconfig>
		EOF
	else \
		mkdir -p $(HOME)/.config/fontconfig;
		tee -a $(HOME)/.config/fontconfig/fonts.conf << 'EOF'
		<?xml version="1.0"?>
		<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
		<fontconfig>
		<match target="font">
			<edit name="antialias" mode="assign">
			<bool>true</bool>
			</edit>
			<edit name="hinting" mode="assign">
			<bool>true</bool>
			</edit>
			<edit mode="assign" name="rgba">
			<const>rgb</const>
			</edit>
			<edit mode="assign" name="hintstyle">
			<const>hintslight</const>
			</edit>
			<edit mode="assign" name="lcdfilter">
			<const>lcddefault</const>
			</edit>
		</match>
		</fontconfig>
		EOF
	fi

## wiki.archlinux.org/title/sysctl#Virtual_memory
## wiki.archlinux.org/title/gaming#Game_environments
apply-settings-swap:						# Configuring for use of Swap/ZRAM and Games.
	@echo -e "# Less use of Swap" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
	@echo -e "vm.swappiness=10" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
	@echo -e "vm.vfs_cache_pressure=50" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
	@echo -e "vm.dirty_ratio=6" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
	@echo -e "vm.dirty_background_ratio=6" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
	@sudo sed -i 's/1048576/2147483642/g' /usr/lib/sysctl.d/10-map-count.conf

apply-qemu-settings:						# Apply QEMU Settings.
	@sudo sed -i '/unix_sock_group/s/^#//g' /etc/libvirt/libvirtd.conf
	@sudo sed -i '/unix_sock_rw_perms/s/^#//g' /etc/libvirt/libvirtd.conf
	@sudo usermod -a -G libvirt $(shell whoami)
	@sudo systemctl start libvirtd
	@sudo systemctl enable libvirtd

apply-podman-settings:						# Disabling possibility of selecting other repositories for downloading container images.
	@sudo sed -i '/unqualified-search-registries/s/^/#/' /etc/containers/registries.conf
	@echo -e "unqualified-search-registries = ['docker.io']" | sudo tee -a /etc/containers/registries.conf

disable-services:							# Disabling unnecessary services.
	@sudo systemctl stop abrt-journal-core.service
	@sudo systemctl stop abrt-oops.service
	@sudo systemctl stop abrt-xorg.service
	@sudo systemctl stop abrtd.service
	@sudo systemctl disable abrt-oops.service
	@sudo systemctl disable abrt-journal-core.service
	@sudo systemctl disable abrt-xorg.service
	@sudo systemctl disable abrtd.service

disable-repos:								# Disabling unnecessary repos.
	@sudo dnf config-manager --set-disabled rpmfusion-nonfree-nvidia-driver
	@sudo dnf config-manager --set-disabled fedora-cisco-openh264
	@sudo dnf config-manager --set-disabled google-chrome 

new-hostname:								# Set new Hostname.
	@sudo hostnamectl set-hostname "tardis"

## github.com/flatpak/xdg-desktop-portal/issues/1070/#issuecomment-1762884545
.ONESHELL:
apply-fix-flameshot:						# Fix for Flameshot.
	@sudo tee /usr/local/bin/flameshot-gui-workaround <<'EOF'
	#!/bin/bash

	env QT_QPA_PLATFORM=wayland flameshot gui
	EOF

	@sudo chmod a+x /usr/local/bin/flameshot-gui-workaround

.ONESHELL:
apply-icon-theme-settings:					# Installation of icons, themes, font and basic settings.
	@theme (){

	curl -fsSL https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest \
	| grep "browser_download_url.*tar.xz" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| xargs wget -q -P /tmp/ \
	&& tar -xf /tmp/*.tar.xz -C $(HOME)/.local/share/themes

	gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

	}

	@icon (){

	wget -cqO- https://git.io/papirus-icon-theme-install | DESTDIR="$(HOME)/.local/share/icons" sh
	wget -cqO- https://git.io/papirus-folders-install | sh
	gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
	papirus-folders -C bluegrey --theme Papirus
	rm $(HOME)/.local/share/icons/ePapirus-Dark -rf
	rm $(HOME)/.local/share/icons/ePapirus -rf
	rm $(HOME)/.local/share/icons/Papirus-Dark -rf
	rm $(HOME)/.local/share/icons/Papirus-Light -rf

	}
	
	@if [ -d "$(HOME)/.local/share/themes" ]; then \
		echo -e "Folder theme already exists.\n"; \
		echo -e "Installing..."; \
		theme; \
	else \
		mkdir -p $(HOME)/.local/share/themes; \
		echo -e "Installing..."; \
		theme; \
	fi

	@if [ -d "$(HOME)/.local/share/icons" ]; then \
		echo -e "Folder icon already exists.\n"; \
		echo -e "Installing..."; \
		icon; \
	else \
		mkdir -p $(HOME)/.local/share/icons; \
		echo -e "Installing..."; \
		icon; \
	fi

	@if [ -d "$(HOME)/.config/fastfetch" ]; then \
		curl -fsSL $(url_fastfetch) -o $(HOME)/.config/fastfetch/config.jsonc; \
	else \
		mkdir -p "$(HOME)/.config/fastfetch"; \
		curl -fsSL $(url_fastfetch) -o $(HOME)/.config/fastfetch/config.jsonc; \
	fi

	@if [ -d "$(HOME)/.config/terminator" ]; then \
		curl -fsSL $(url_terminator) -o $(HOME)/.config/terminator/config; \
	else \
		mkdir -p "$(HOME)/.config/terminator"; \
		curl -fsSL $(url_terminator) -o $(HOME)/.config/terminator/config; \
	fi

	@if [ -d "$(HOME)/.config/micro" ]; then \
		curl -fsSL $(url_micro) -o $(HOME)/.config/micro/settings.json; \
	else \
		mkdir -p "$(HOME)/.config/micro"; \
		curl -fsSL $(url_micro) -o $(HOME)/.config/micro/settings.json; \
	fi

	@if [ -d "$(HOME)/.local/share/fonts" ]; then \
		curl -fsSL $(url_fantasque) -o $(HOME)/.local/share/fonts/FantasqueSansMNerdFontMono-Regular.ttf; \
	else \
		mkdir -p "$(HOME)/.local/share/fonts"; \
		curl -fsSL $(url_fantasque) -o $(HOME)/.local/share/fonts/FantasqueSansMNerdFontMono-Regular.ttf; \
	fi

	@if [ -d "$(HOME)/.config/ulauncher/user-themes" ]; then \
		curl -fsSL $(url_ulauncher) -o $(HOME)/.config/ulauncher/user-themes/transparent-adwaita.zip; \
		unzip -qq /tmp/transparent-adwaita.zip; \
	else \
		mkdir -p "$(HOME)/.config/ulauncher/user-themes; \
		curl -fsSL $(url_ulauncher) -o $(HOME)/.config/ulauncher/user-themes/transparent-adwaita.zip; \
		unzip -qq /tmp/transparent-adwaita.zip; \
	fi
	
	@curl -fsSL $(url_starship) -o $(HOME)/.config/starship.toml;
	@curl -fsSL $(url_vim) -o $(HOME)/.vimrc;
	@curl -fsSL $(url_nano) -o $(HOME)/.nanorc;
	@curl -fsSL $(url_zsh_aliases) -o $(HOME)/.zsh_aliases;

	@wget -O /tmp/ubuntu.zip https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
	@unzip -qq /tmp/ubuntu.zip -d /tmp
	@sudo cp -a /tmp/ubuntu-font-family-0.83/*.ttf $(HOME)/.local/share/fonts
	@sudo fc-cache -f -v >/dev/null

	@sudo flatpak override --filesystem="xdg-data/themes:ro"
	@sudo flatpak override --filesystem="xdg-data/icons:ro"
	@gsettings set org.gnome.desktop.default-applications.terminal exec terminator
	@gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
	@gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'chromium-browser.desktop', 'codium.desktop', 'appimagekit-joplin.desktop']"
	
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

finish-clenaning:							# Finishing and cleaning.
	@sudo dnf autoremove -y
	@sudo rm $(directory_downloads)/ -rf
	@sudo systemctl daemon-reload

apply-requirements:							# Apply requirements section in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 39 ] || [ $(FEDORA_RELEASE) = 40 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) dnf-tweaks; \
		$(MAKE) app-remover; \
		$(MAKE) add-rpm-fusion; \
		$(MAKE) add-vscodium-repo; \
		$(MAKE) add-heroic-repo; \
		$(MAKE) add-flathub; \
		$(MAKE) update-repos; \
	else \
		echo -e "\e[31;1mDistro not approved for use with this script.\e[m"; \
		exit 1; \
	fi
	
apply-execution:							# Apply execution section in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 39 ] || [ $(FEDORA_RELEASE) = 40 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) app-install; \
		$(MAKE) add-multimedia; \
		$(MAKE) install-amd-mesa; \
		$(MAKE) install-qemu; \
		$(MAKE) install-flatpaks; \
		$(MAKE) install-joplin; \
		$(MAKE) install-rpm; \
		$(MAKE) install-codium-ex; \
		$(MAKE) install-tinifier; \
		$(MAKE) install-lact; \
		$(MAKE) install-ms-fonts; \
	else \
		echo -e "\e[31;1mDistro not approved for use with this script.\e[m"; \
		exit 1; \
	fi
	
apply-post-install:							# Apply post-install section in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 39 ] || [ $(FEDORA_RELEASE) = 40 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) apply-performance; \
		$(MAKE) apply-font-fix; \
		$(MAKE) apply-settings-swap; \
		$(MAKE) apply-qemu-settings; \
		$(MAKE) apply-podman-settings; \
		$(MAKE) disable-services; \
		$(MAKE) disable-repos; \
		$(MAKE) new-hostname; \
		$(MAKE) apply-fix-flameshot; \
		$(MAKE) apply-icon-theme-settings; \
		$(MAKE) finish-clenaning; \
	else \
		echo -e "\e[31;1mDistro not approved for use with this script.\e[m"; \
		exit 1; \
	fi
	
apply-all:									# Apply all sections in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 39 ] || [ $(FEDORA_RELEASE) = 40 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) dnf-tweaks; \
		$(MAKE) app-remover; \
		$(MAKE) add-rpm-fusion; \
		$(MAKE) add-vscodium-repo; \
		$(MAKE) add-heroic-repo; \
		$(MAKE) add-flathub; \
		$(MAKE) update-repos; \
		$(MAKE) app-install; \
		$(MAKE) add-multimedia; \
		$(MAKE) install-amd-mesa; \
		$(MAKE) install-qemu; \
		$(MAKE) install-flatpaks; \
		$(MAKE) install-joplin; \
		$(MAKE) install-rpm; \
		$(MAKE) install-codium-ex; \
		$(MAKE) install-tinifier; \
		$(MAKE) install-lact; \
		$(MAKE) install-ms-fonts; \
		$(MAKE) apply-performance; \
		$(MAKE) apply-font-fix; \
		$(MAKE) apply-settings-swap; \
		$(MAKE) apply-qemu-settings; \
		$(MAKE) apply-podman-settings; \
		$(MAKE) disable-services; \
		$(MAKE) disable-repos; \
		$(MAKE) new-hostname; \
		$(MAKE) apply-fix-flameshot; \
		$(MAKE) apply-icon-theme-settings; \
		$(MAKE) finish-clenaning; \
	else \
		echo -e "\e[31;1mDistro not approved for use with this script.\e[m"; \
		exit 1; \
	fi

help:										# Show list of available commands and your descriptions.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
