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
### 		Last Edition 18/01/2025. <https://github.com/ciro-mota/my-pos-install/commits/main>

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ VARIABLES AND REQUIREMENTS --------------------------------------- #

### Dynamic repos and download links.

url_jopplin="https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh"
url_flathub="https://flathub.org/repo/flathub.flatpakrepo"
url_fastfetch="https://github.com/ciro-mota/my-pos-install/raw/main/confs/fastfetch/config.jsonc"
url_terminator="https://github.com/ciro-mota/my-pos-install/raw/main/confs/terminator/config"
url_micro="https://github.com/ciro-mota/my-pos-install/raw/main/confs/micro/settings.json"
url_starship="https://github.com/ciro-mota/my-pos-install/raw/main/confs/starship/starship.toml"
url_vim="https://github.com/ciro-mota/my-pos-install/raw/main/confs/vim/.vimrc"
url_nano="https://github.com/ciro-mota/my-pos-install/raw/main/confs/nano/.nanorc"
url_zsh_aliases="https://github.com/ciro-mota/my-pos-install/raw/main/confs/zsh/.zsh_aliases"
url_ulauncher="https://github.com/ciro-mota/my-pos-install/raw/main/confs/ulauncher/transparent-adwaita.zip"

### Installation and uninstallation packages.

apps_remove=(cheese 
	gnome-abrt 
	gnome-boxes 
	gnome-clocks 
	gnome-connections 
	gnome-contacts 
	gnome-maps 
	gnome-photos 
	gnome-software 
	gnome-text-editor 
	gnome-tour 
	libreoffice-* 
	mediawriter 
	nvidia-gpu-firmware 
	PackageKit 
	totem 
	rhythmbox
	virtualbox-guest-additions-*
	yelp)

apps_install=(adw-gtk3-theme 
	android-tools 
	bat 
	btop 
	cabextract 
	chromium 
	containerd.io 
	codium 
	cowsay 
	docker-compose 
	fastfetch 
	ffmpegthumbnailer 
	file-roller 
	flameshot 
	fortune-mod 
	fragments 
	gedit 
	gimp 
	gnome-tweaks 
	google-noto-emoji-fonts 
	goverlay 
	hadolint 
	heroic-games-launcher-bin 
	hugo 
	ksnip 
	lolcat 
	lpf 
	lpf-cleartype-fonts 
	lpf-mscore-fonts 
	lpf-mscore-tahoma-fonts 
	lsd 
	mangohud 
	nautilus-python 
	micro 
	mozilla-openh264 
	opentofu 
	pre-commit 
	qemu-system-x86 
	ulauncher 
	unrar-free 
	vim-enhanced 
	vlc 
	vlc-plugins-freeworld 
	xorg-x11-font-utils 
	zsh)

flatpak_install=(com.github.finefindus.eyedropper
	com.github.GradienceTeam.Gradience 
	com.mattjakeman.ExtensionManager 
	com.valvesoftware.Steam 
	org.libreoffice.LibreOffice 
	org.remmina.Remmina 
	org.telegram.desktop)

code_extensions=(AquaSecurityOfficial.trivy-vulnerability-scanner
	dendron.dendron-markdown-shortcuts
	eamodio.gitlens
	emmanuelbeziat.vscode-great-icons
	exiasr.hadolint
	foxundermoon.shell-format
	HashiCorp.terraform
	ritwickdey.LiveServer
	MS-CEINTL.vscode-language-pack-pt-BR
	Shan.code-settings-sync
	streetsidesoftware.code-spell-checker
	streetsidesoftware.code-spell-checker-portuguese-brazilian
	timonwong.shellcheck
	zhuangtongfa.Material-theme)

directory_downloads="$HOME/Downloads/apps"

# ------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------------------- TEST --------------------------------------------------- #
### Check if the distribution is correct.

if [[ $(awk '{print $3}' /etc/fedora-release) =~ ^(40|41)$ ]]
then
	echo ""
	echo -e "\e[32;1mCorrect distro. Continuing with the script...\e[m"
	echo ""
else
	echo -e "\e[31;1mDistro not approved for use with this script.\e[m"
	exit 1
fi

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ APPLYING REQUIREMENTS -------------------------------------------- #
### Tweaks to dnf.conf

echo -e "color=always" | sudo tee -a /etc/dnf/dnf.conf
echo -e "clean_requirements_on_remove=True" | sudo tee -a /etc/dnf/dnf.conf
echo -e "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

### Uninstalling unnecessary packages.

for name_of_remove in "${apps_remove[@]}"; do
    sudo dnf remove "$name_of_remove" -y
done

### Adding RPM Fusion.

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
sudo sed -i '/#baseurl/a baseurl=http://ftp-stud.hs-esslingen.de/pub/Mirrors/rpmfusion.org/free/fedora/updates/$releasever/$basearch/' rpmfusion*.repo
sudo sed -i 's/^metalink/#&/' /etc/yum.repos.d/rpmfusion*.repo

### VSCodium

sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF

### Heroic Games

sudo dnf copr enable atim/heroic-games-launcher -y

### Flathub

flatpak remote-add --if-not-exists flathub "$url_flathub"

### Updating system after adding new repos.

sudo dnf clean all
sudo sed -r -i s/'(^metalink.*basearch)/\1\&country=DE/' fedora*
sudo dnf upgrade --refresh -y

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUTION ------------------------------------------------- #

### Install of apps list.

for name_of_app in "${apps_install[@]}"; do
    sudo dnf install "$name_of_app" -y
done

### Enabling multimedia support:

sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav \
--exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

# Install Mesa AMD components from rpmfusion.

sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y

### Installing QEMU/Virt-Manager

sudo dnf install @virtualization -y

### Install of Flatpak apps.

for name_of_flatpak in "${flatpak_install[@]}"; do
    sudo flatpak install flathub -y "$name_of_flatpak"
done

### Install of Jopplin.

wget -O - $url_jopplin | bash

### Install of Codium extensions.

for code_ext in "${code_extensions[@]}"; do
    codium --install-extension "$code_ext" 2> /dev/null
done

### Install Tinifier.

wget -O /tmp/tinifier https://github.com/tarampampam/tinifier/releases/download/v4.1.0/tinifier-linux-amd64
sudo cp /tmp/tinifier /usr/local/bin
sudo chmod +x /usr/local/bin/tinifier

### Install some tools
DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -OL https://github.com/wagoodman/dive/releases/download/v"${DIVE_VERSION}"/dive_"${DIVE_VERSION}"_linux_amd64.rpm
rpm -i dive_"${DIVE_VERSION}"_linux_amd64.rpm

curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --

curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Install LACT AMD GPU Tool.

curl -fsSL https://api.github.com/repos/ilya-zlobintsev/LACT/releases/latest \
| grep "browser_download_url.*fedora-40.rpm" \
| cut -d : -f 2,3 \
| tail -1 \
| tr -d \" \
| xargs wget -q -P /tmp/ \
&& sudo dnf install -y /tmp/*fedora-40.rpm

# ------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------------- POS-INSTALL --------------------------------------------- #

### Performance improvements.
## wiki.archlinux.org/title/improving_performance#Changing_I/O_scheduler

sudo tee -a /etc/udev/rules.d/60-ioschedulers.rules << 'EOF'
# Define o escalonador para NVMe
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"

# Define o escalonador para SSD e eMMC
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

# Define o escalonador para discos rotativos
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
EOF

### Font fixes.
## wiki.manjaro.org/index.php/Improve_Font_Rendering
## discussion.fedoraproject.org/t/fonts-in-gtk-4-apps-look-different-more-blurry/66778

if [ -d "$HOME"/.config/gtk-4.0 ]
then
	echo -e "gtk-hint-font-metrics=1" | tee -a "$HOME"/.config/gtk-4.0/settings.ini
else
	mkdir -p "$HOME"/.config/gtk-4.0
	echo -e "gtk-hint-font-metrics=1" | tee -a "$HOME"/.config/gtk-4.0/settings.ini
fi

if [ -d "$HOME"/.config/fontconfig ]
then 
tee -a "$HOME"/.config/fontconfig/fonts.conf << 'EOF'
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
else 
mkdir -p "$HOME"/.config/fontconfig;
tee -a "$HOME"/.config/fontconfig/fonts.conf << 'EOF'
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

### Configuring for use of Swap/ZRAM.
## wiki.archlinux.org/title/sysctl#Virtual_memory

echo -e "# Less use of Swap" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
echo -e "vm.swappiness=10" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
echo -e "vm.vfs_cache_pressure=50" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
echo -e "vm.dirty_ratio=6" | sudo tee -a /usr/lib/sysctl.d/50-default.conf
echo -e "vm.dirty_background_ratio=6" | sudo tee -a /usr/lib/sysctl.d/50-default.conf

## wiki.archlinux.org/title/gaming#Game_environments

sudo sed -i 's/1048576/2147483642/g' /usr/lib/sysctl.d/10-map-count.conf

### QEMU Settings.

sudo sed -i '/unix_sock_group/s/^#//g' /etc/libvirt/libvirtd.conf
sudo sed -i '/unix_sock_rw_perms/s/^#//g' /etc/libvirt/libvirtd.conf
sudo usermod -a -G libvirt "$(whoami)"
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

### Podman Settings.

sudo sed -i '/unqualified-search-registries/s/^/#/' /etc/containers/registries.conf
echo -e "unqualified-search-registries = ['docker.io']" | sudo tee -a /etc/containers/registries.conf

### Disabling unnecessary services.

sudo systemctl stop abrt-journal-core.service
sudo systemctl stop abrt-oops.service
sudo systemctl stop abrt-xorg.service
sudo systemctl stop abrtd.service
sudo systemctl disable abrt-oops.service
sudo systemctl disable abrt-journal-core.service
sudo systemctl disable abrt-xorg.service
sudo systemctl disable abrtd.service

### Disabling unnecessary repos.

sudo dnf config-manager --set-disabled rpmfusion-nonfree-nvidia-driver
sudo dnf config-manager --set-disabled google-chrome
sudo dnf config-manager --set-disabled copr:copr.fedorainfracloud.org:phracek:PyCharm

### Set new Hostname.

sudo hostnamectl set-hostname "tardis"

### Fix for Flameshot.
### github.com/flatpak/xdg-desktop-portal/issues/1070/#issuecomment-1762884545

sudo tee /usr/local/bin/flameshot-gui-workaround <<'EOF'
#!/bin/bash

env QT_QPA_PLATFORM=wayland flameshot gui
EOF

sudo chmod a+x /usr/local/bin/flameshot-gui-workaround

### Apply my service and timer for backups.
### wiki.archlinux.org/title/systemd/Timers

sudo tee /etc/systemd/user/mybackup.timer <<'EOF'
[Unit]
Description=My Job Backup

[Timer]
OnCalendar=Fri 15:00
Persistent=true

[Install]
WantedBy=mybackup.target
EOF
	
sudo tee /etc/systemd/user/mybackup.service <<'EOF'
[Unit]
Description=My Backup Job Service

[Service]
Type=simple
ExecStart=/usr/local/bin/rsync_backup.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF
	
systemctl  enable --user mybackup.timer
systemctl  enable --user mybackup.service

### Installation of icons, themes, font and basic settings.

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

icon (){

wget -cqO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.local/share/icons" sh
wget -cqO- https://git.io/papirus-folders-install | sh
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
papirus-folders -C bluegrey --theme Papirus
rm "$HOME"/.local/share/icons/ePapirus-Dark -rf
rm "$HOME"/.local/share/icons/ePapirus -rf
rm "$HOME"/.local/share/icons/Papirus-Dark -rf
rm "$HOME"/.local/share/icons/Papirus-Light -rf

}

if [ -d "$HOME"/.local/share/icons ]
then
  echo -e "Folder already exists.\n"
  echo -e "Installing..."
  icon
else
  mkdir -p "$HOME"/.local/share/icons
  echo -e "Installing..."
  icon
fi

if [ -d "$HOME"/.config/fastfetch ]
then
	wget  "$url_fastfetch" -P "$HOME"/.config/fastfetch
else
	mkdir -p "$HOME"/.config/fastfetch
	wget  "$url_fastfetch" -P "$HOME"/.config/fastfetch
fi

if [ -d "$HOME"/.config/terminator ]
then
	wget  "$url_terminator" -P "$HOME"/.config/terminator
else
	mkdir -p "$HOME"/.config/terminator
	wget  "$url_terminator" -P "$HOME"/.config/terminator
fi

if [ -d "$HOME"/.config/micro ]
then \
	wget  "$url_micro" -P "$HOME"/.config/micro; \
else \
	mkdir -p "$HOME"/.config/micro; \
	wget  "$url_micro" -P "$HOME"/.config/micro; \
fi

if [ -d "$HOME"/.config/ulauncher/user-themes ]; then 
	curl -fsSL "$url_ulauncher" -o "$HOME"/.config/ulauncher/user-themes/transparent-adwaita.zip
	unzip -qq /tmp/transparent-adwaita.zip
else \
	mkdir -p "$HOME"/.config/ulauncher/user-themes
	curl -fsSL "$url_ulauncher" -o "$HOME"/.config/ulauncher/user-themes/transparent-adwaita.zip;
	unzip -qq /tmp/transparent-adwaita.zip
fi

wget "$url_starship" -P "$HOME"/.config/starship.toml;
wget "$url_vim" -P "$HOME"/.vimrc;
wget "$url_nano" -P "$HOME"/.nanorc;
wget "$url_zsh_aliases" -P "$HOME"/.zsh_aliases;

func_font() {

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

if [ -d "$HOME"/.local/share/fonts ]
then
	func_font
else
	mkdir -p "$HOME"/.local/share/fonts
	func_font
fi

sudo flatpak override --filesystem="xdg-data/themes:ro"
sudo flatpak override --filesystem="xdg-data/icons:ro"
gsettings set org.gnome.desktop.default-applications.terminal exec terminator
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'chromium.desktop', 'codium.desktop', 'appimagekit-joplin.desktop']"
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### Finishing and cleaning.
sudo dnf autoremove -y

### Cleaning temporary download folder.
sudo rm "$directory_downloads"/ -rf
sudo systemctl daemon-reload
