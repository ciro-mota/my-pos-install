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
### 		Last Edition 07/11/2025. <https://github.com/ciro-mota/my-pos-install/commits/main>

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ VARIABLES AND REQUIREMENTS --------------------------------------- #
### Commom variables.
MAKEFLAGS += --no-print-directory
FEDORA_RELEASE = $(shell head /etc/fedora-release | sed 's/.* \([0-9]\+\) .*/\1/')
.SHELLFLAGS = -ec

### Dynamic repos and download links.
url_flathub = https://flathub.org/repo/flathub.flatpakrepo
url_fastfetch = https://github.com/ciro-mota/my-pos-install/raw/main/confs/fastfetch/config.jsonc
url_kitty="https://github.com/ciro-mota/my-pos-install/raw/main/confs/kitty/kitty.conf"
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

apps = adw-gtk3-theme \
	aha \
	android-tools \
	ansible \
	ansible-lint \
	awscli \
	bat \
	btop \
	cabextract \
	chromium \
	containerd \
	codium \
	cowsay \
	docker-compose \
	duf \
	fastfetch \
	ffmpegthumbnailer \
	file-roller \
	flameshot \
	fortune-mod \
	fragments \
	gedit \
	gimp \
	gnome-shell-extension-appindicator \
	gnome-tweaks \
	google-noto-emoji-fonts \
	goverlay \
	grepcidr \
	hadolint \
	heroic-games-launcher-bin \
	hugo \
	ksnip \
	kopia \
	lolcat \
	lpf \
	lpf-cleartype-fonts \
	lpf-mscore-fonts \
	lpf-mscore-tahoma-fonts \
	lsd \
	mangohud \
	nautilus-python \
	micro \
	mozilla-openh264 \
	opentofu \
	pre-commit \
	qemu-system-x86 \
	ulauncher \
	unrar-free \
	vim-enhanced \
	vlc \
	vlc-plugins-freeworld \
	xorg-x11-font-utils \
	zsh

flatpaks = be.alexandervanhee.gradia \
	com.github.finefindus.eyedropper \
	com.github.GradienceTeam.Gradience \
	com.mattjakeman.ExtensionManager \
	com.valvesoftware.Steam \
	io.github.celluloid_player.Celluloid \
	md.obsidian.Obsidian \
	org.libreoffice.LibreOffice \
	org.onlyoffice.desktopeditors \
	org.remmina.Remmina \
	org.telegram.desktop

code_extensions = anchoreinc.grype-vscode \
	eamodio.gitlens \
	emmanuelbeziat.vscode-great-icons \
	exiasr.hadolint \
	foxundermoon.shell-format \
	github.copilot \
	hashicorp.terraform \
	iamhyc.overleaf-workshop \
	ms-python.black-formatter \
	ms-python.python \
	ritwickdey.liveserver \
	streetsidesoftware.code-spell-checker \
	streetsidesoftware.code-spell-checker-portuguese-brazilian \
	timonwong.shellcheck \
	upstash.context7-mcp \
	yzhang.markdown-all-in-one \
	zhuangtongfa.material-theme \
	zokugun.cron-tasks

directory_downloads = $(HOME)/Downloads/apps

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ APPLYING REQUIREMENTS -------------------------------------------- #
dnf-tweaks:									# Apply Tweaks to dnf.conf
	@echo -e "color=always" | sudo tee -a /etc/dnf/dnf.conf
	@echo -e "clean_requirements_on_remove=True" | sudo tee -a /etc/dnf/dnf.conf
	@echo -e "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

app-remover:								# Uninstalling unnecessary packages.
	@sudo dnf remove -y $(apps_remover)

add-rpm-fusion:								# Adding RPM Fusion.
	@sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(shell rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(shell rpm -E %fedora).noarch.rpm -y
	@sudo sed -i '/#baseurl/a baseurl=http://ftp-stud.hs-esslingen.de/pub/Mirrors/rpmfusion.org/free/fedora/updates/$releasever/$basearch/' rpmfusion*.repo
	@sudo sed -i 's/^metalink/#&/' /etc/yum.repos.d/rpmfusion*.repo

.ONESHELL:
add-vscodium-repo:							# Adding VSCodium repo.
	@sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
	@printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo

add-heroic-repo:							# Adding Heroic Games repo.
	@sudo dnf copr enable atim/heroic-games-launcher -y

.ONESHELL:
add-copia-repo:								# Adding Kopia backup repo.
	@sudo rpm --import https://kopia.io/signing-key
	@sudo tee /etc/yum.repos.d/kopia.repo << 'EOF'
	[Kopia]
	name=Kopia
	baseurl=http://packages.kopia.io/rpm/stable/\$basearch/
	gpgcheck=1
	enabled=1
	gpgkey=https://kopia.io/signing-key
	EOF	

add-flathub:								# Adding Flathub repo.
	@flatpak remote-add --if-not-exists flathub $(url_flathub)

update-repos:								# Updating system after adding new repos.
	@sudo dnf clean all
	@sudo sed -i '/^baseurl/s/^/#/; /^metalink/s/^/#/; /^name=/a baseurl=http://ftp-stud.hs-esslingen.de/pub/Mirrors/rpmfusion.org/free/fedora/releases/$releasever/Everything/$basearch/os/' /etc/yum.repos.d/rpmfusion*.repo
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

install-qemu:								# Installing QEMU/Virt-Manager.
	@sudo dnf install @virtualization -y

install-flatpaks:							# Install of Flatpak apps.
	@sudo flatpak install flathub -y $(flatpaks)

install-codium-ex:							# Configuration and Install of Codium extensions.
	@tee -a "$HOME"/.config/VSCodium/product.json << 'EOF'
	{
	"extensionsGallery": {
		"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
		"itemUrl": "https://marketplace.visualstudio.com/items",
		"cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
		"controlUrl": ""
		}
	}
	EOF
	
	@for code_ext in $(code_extensions); do \
		codium --install-extension $$code_ext 2> /dev/null; \
	done
	
install-lact:								# Install LACT AMD GPU Tool.
	@curl -fsSL https://api.github.com/repos/ilya-zlobintsev/LACT/releases/latest \
	| grep "browser_download_url.*fedora-40.rpm" \
	| cut -d : -f 2,3 \
	| tail -1 \
	| tr -d \" \
	| xargs wget -q -P /tmp/ \
	&& sudo dnf install -y /tmp/*fedora-40.rpm
	
install-nvm:								# Install Node Version Manager.
	@curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | bash
	@nvm install "$(nvm ls-remote | grep "Latest LTS" | sed -E 's/.*v([0-9]+\.[0-9]+\.[0-9]+).*/v\1/' | tail -1)"

# # ------------------------------------------------------------------------------------------------------------- #
# # -------------------------------------------------- POST-INSTALL --------------------------------------------- #
## wiki.archlinux.org/title/improving_performance#Changing_I/O_scheduler
.ONESHELL:
apply-performance:							# Apply performance disk improvements.
	@sudo tee -a /etc/udev/rules.d/60-ioschedulers.rules << 'EOF'
	# Define o escalonador para NVMe
	ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"

	# Define o escalonador para SSD e eMMC
	ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

	# Define o escalonador para discos rotativos
	ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
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
			  <alias>
			    <family>monospace</family>
			    <prefer>
			      <family>FantasqueSansM Nerd Font Mono</family>
			      <family>Noto Color Emoji</family>
			     </prefer>
			  </alias>
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
	@sudo sed -i '/^[[:space:]]*#/! s/^/# /' /etc/containers/registries.conf.d/000-shortnames.conf


apply-ansible-settings:						# Apply better output config
	@sudo tee -a /etc/ansible/ansible.cfg << 'EOF'
	[defaults]
	stdout_callback = community.general.yaml
	EOF
	@ansible-galaxy collection install community.docker

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
	@sudo dnf config-manager --set-disabled google-chrome
	@sudo dnf config-manager --set-disabled copr:copr.fedorainfracloud.org:phracek:PyCharm

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

## wiki.archlinux.org/title/systemd/Timers
.ONESHELL:
apply-service-timer:						# Apply my service and timer for backups.
	@sudo tee /etc/systemd/user/mybackup.timer <<'EOF'
	[Unit]
	Description=My Job Backup

	[Timer]
	OnCalendar=Fri 15:00
	Persistent=true

	[Install]
	WantedBy=mybackup.target
	EOF
	
	@sudo tee /etc/systemd/user/mybackup.service <<'EOF'
	[Unit]
	Description=My Backup Job Service

	[Service]
	Type=simple
	ExecStart=/usr/local/bin/rsync_backup.sh
	Restart=on-failure

	[Install]
	WantedBy=default.target
	EOF
	
	@systemctl  enable --user mybackup.timer
	@systemctl  enable --user mybackup.service

.ONESHELL:
apply-icon-theme-settings:					# Installation of icons, themes, font and basic settings.
	@gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

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

	@if [ -d "$HOME"/.config/kitty ]
	then
		wget "$url_kitty" -P "$HOME"/.config/kitty
	else
		mkdir -p "$HOME"/.config/kitty
		wget "$url_kitty" -P "$HOME"/.config/kitty
	fi

	@if [ -d "$(HOME)/.config/micro" ]; then \
		curl -fsSL $(url_micro) -o $(HOME)/.config/micro/settings.json; \
	else \
		mkdir -p "$(HOME)/.config/micro"; \
		curl -fsSL $(url_micro) -o $(HOME)/.config/micro/settings.json; \
	fi

	@if [ -d "$(HOME)/.config/ulauncher/user-themes" ]; then \
		curl -fsSL $(url_ulauncher) -o $(HOME)/.config/ulauncher/user-themes/transparent-adwaita.zip; \
		unzip -qq /tmp/transparent-adwaita.zip; \
	else \
		mkdir -p "$(HOME)/.config/ulauncher/user-themes; \
		curl -fsSL $(url_ulauncher) -o $(HOME)/.config/ulauncher/user-themes/transparent-adwaita.zip; \
		unzip -qq /tmp/transparent-adwaita.zip; \
	fi
	
	@func_font() {

	curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
	| grep "browser_download_url.*FantasqueSansMono.zip" \
	| cut -d : -f 2,3 \
	| tail -1 \
	| tr -d \" \
	| xargs wget -q -P /tmp/ \
	&& unzip -qq /tmp/FantasqueSansMono.zip

	curl -fsSL https://api.github.com/repos/canonical/Ubuntu-Sans-fonts/releases/latest \
		| grep "browser_download_url.*.zip" \
		| cut -d : -f 2,3 \
		| tail -1 \
		| tr -d \" \
		| xargs wget -O /tmp/ubuntu.zip -q -P /tmp/ \
	&& unzip -qq /tmp/ubuntu.zip

	cp -a /tmp/UbuntuSans-fonts-*/ttf/*.ttf "$HOME"/.local/share/fonts
	cp -a /tmp/FantasqueSansMNerdFont*.ttf "$HOME"/.local/share/fonts
	sudo fc-cache -f -v >/dev/null
	lpf update

	}

	@if [ -d "$HOME"/.local/share/fonts ]
	then
		func_font
	else
		mkdir -p "$HOME"/.local/share/fonts
		func_font
	fi

	@sudo flatpak override --filesystem="xdg-data/themes:ro"
	@sudo flatpak override --filesystem="xdg-data/icons:ro"
	@gsettings set org.gnome.desktop.default-applications.terminal exec terminator
	@gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
	@gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'chromium-browser.desktop', 'codium.desktop', 'md.obsidian.Obsidian']"
	@gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11' 
	@gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'
	@gsettings set org.gnome.SessionManager logout-prompt false

	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

finish-clenaning:							# Finishing and cleaning.
	@sudo dnf autoremove -y
	@sudo rm $(directory_downloads)/ -rf
	@sudo systemctl daemon-reload

apply-requirements:							# Apply requirements section in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 42 ] || [ $(FEDORA_RELEASE) = 43 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) dnf-tweaks; \
		$(MAKE) app-remover; \
		$(MAKE) add-rpm-fusion; \
		$(MAKE) add-vscodium-repo; \
		$(MAKE) add-heroic-repo; \
		$(MAKE) add-copia-repo; \
		$(MAKE) add-flathub; \
		$(MAKE) update-repos; \
	else \
		echo -e "\e[31;1mDistro not approved for use with this script.\e[m"; \
		exit 1; \
	fi
	
apply-execution:							# Apply execution section in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 42 ] || [ $(FEDORA_RELEASE) = 43 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) app-install; \
		$(MAKE) add-multimedia; \
		$(MAKE) install-amd-mesa; \
		$(MAKE) install-qemu; \
		$(MAKE) install-flatpaks; \
		$(MAKE) install-codium-ex; \
		$(MAKE) install-lact; \
		$(MAKE) install-nvm; \
	else \
		echo -e "\e[31;1mDistro not approved for use with this script.\e[m"; \
		exit 1; \
	fi
	
apply-post-install:							# Apply post-install section in the system if the distro is correct.
	@if [ $(FEDORA_RELEASE) = 42 ] || [ $(FEDORA_RELEASE) = 43 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) apply-performance; \
		$(MAKE) apply-font-fix; \
		$(MAKE) apply-settings-swap; \
		$(MAKE) apply-qemu-settings; \
		$(MAKE) apply-podman-settings; \
		$(MAKE) apply-ansible-settings; \
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
	@if [ $(FEDORA_RELEASE) = 42 ] || [ $(FEDORA_RELEASE) = 43 ]; then \
		echo ""; \
		echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"; \
		echo ""; \
		$(MAKE) dnf-tweaks; \
		$(MAKE) app-remover; \
		$(MAKE) add-rpm-fusion; \
		$(MAKE) add-vscodium-repo; \
		$(MAKE) add-heroic-repo; \
		$(MAKE) add-copia-repo; \
		$(MAKE) add-flathub; \
		$(MAKE) update-repos; \
		$(MAKE) app-install; \
		$(MAKE) add-multimedia; \
		$(MAKE) install-amd-mesa; \
		$(MAKE) install-qemu; \
		$(MAKE) install-flatpaks; \
		$(MAKE) install-codium-ex; \
		$(MAKE) install-lact; \
		$(MAKE) install-nvm; \
		$(MAKE) apply-performance; \
		$(MAKE) apply-font-fix; \
		$(MAKE) apply-settings-swap; \
		$(MAKE) apply-qemu-settings; \
		$(MAKE) apply-podman-settings; \
		$(MAKE) apply-ansible-settings; \
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
