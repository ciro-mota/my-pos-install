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
### 		Last Edition 24/05/2024. <https://github.com/ciro-mota/my-pos-install/commits/main>

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------ VARIABLES AND REQUIREMENTS --------------------------------------- #

### Dynamic repos and download links.

url_jopplin="https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh"
url_flathub="https://flathub.org/repo/flathub.flatpakrepo"
url_tviewer="https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm"
url_fastfetch="https://github.com/ciro-mota/my-pos-install/raw/main/confs/fastfetch/config.jsonc"
url_terminator="https://github.com/ciro-mota/my-pos-install/raw/main/confs/terminator/config"
url_micro="https://github.com/ciro-mota/my-pos-install/raw/main/confs/micro/settings.json"
url_starship="https://github.com/ciro-mota/my-pos-install/raw/main/confs/starship/starship.toml"
url_vim="https://github.com/ciro-mota/my-pos-install/raw/main/confs/vim/.vimrc"
url_nano="https://github.com/ciro-mota/my-pos-install/raw/main/confs/nano/.nanorc"
url_zsh_aliases="https://github.com/ciro-mota/my-pos-install/raw/main/confs/zsh/.zsh_aliases"
url_ulauncher="https://github.com/ciro-mota/my-pos-install/raw/main/confs/ulauncher/transparent-adwaita.zip"
url_fantasque="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FantasqueSansMono/Regular/FantasqueSansMNerdFontMono-Regular.ttf"

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

apps_install=(android-tools 
	bat 
	btop 
	cabextract 
	chromium 
	containerd.io 
	codium 
	cowsay 
	fastfetch 
	ffmpegthumbnailer 
	file-roller 
	flameshot 
	fortune-mod 
	gedit 
	gimp 
	gnome-tweaks 
	goverlay 
	hadolint 
	heroic-games-launcher-bin 
	hugo 
	ksnip 
	lolcat 
	lsd 
	mangohud 
	micro 
	mozilla-openh264 
	opentofu 
	qBittorrent 
	qemu-system-x86 
	terminator 
	steam 
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

if [[ $(awk '{print $3}' /etc/fedora-release) =~ ^(39|40)$ ]]
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

sudo echo -e "color=always" | sudo tee -a /etc/dnf/dnf.conf
sudo echo -e "clean_requirements_on_remove=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo -e "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

### Uninstalling unnecessary packages.

for name_of_remove in "${apps_remove[@]}"; do
    sudo dnf remove "$name_of_remove" -y
done

### Adding RPM Fusion.

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y

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
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y

### Installing QEMU/Virt-Manager

sudo dnf install @virtualization -y

### Install of Flatpak apps.

for name_of_flatpak in "${flatpak_install[@]}"; do
    sudo flatpak install flathub -y "$name_of_flatpak"
done

### Install of Jopplin.

wget -O - $url_jopplin | bash

### Downloading and installing .rpm packages.

mkdir -p "$directory_downloads"
wget "$url_tviewer" -P "$directory_downloads"
sudo dnf install -y "$directory_downloads"/*.rpm

### Install of Codium extensions.

for code_ext in "${code_extensions[@]}"; do
    codium --install-extension "$code_ext" 2> /dev/null
done

### Install Tinifier.

wget -O /tmp/tinifier https://github.com/tarampampam/tinifier/releases/download/v4.1.0/tinifier-linux-amd64
sudo cp /tmp/tinifier /usr/local/bin
sudo chmod +x /usr/local/bin/tinifier

# Install LACT AMD GPU Tool.

curl -fsSL https://api.github.com/repos/ilya-zlobintsev/LACT/releases/latest \
| grep "browser_download_url.*fedora-40.rpm" \
| cut -d : -f 2,3 \
| tail -1 \
| tr -d \" \
| xargs wget -q -P /tmp/ \
&& sudo dnf install -y /tmp/*fedora-40.rpm

### Installing Microsoft Fonts.

yes | sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

# ------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------------- POS-INSTALL --------------------------------------------- #

### Performance improvements.
## wiki.archlinux.org/title/improving_performance#Changing_I/O_scheduler

sudo tee -a /etc/udev/rules.d/60-ioschedulers.rules << 'EOF'
# HDD
ACTION=="add|change", KERNEL=="sdb", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

# SSD
ACTION=="add|change", KERNEL=="sda", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
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

### Installation of icons, themes, font and basic settings.

theme (){

curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | grep "browser_download_url.*tar.xz" | \
cut -d : -f 2,3 | tr -d \" | \
wget -P "$directory_downloads" -i-
tar xf "$directory_downloads"/*.tar.xz -C "$HOME"/.local/share/themes

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

}

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

if [ -d "$HOME"/.local/share/themes ]
then
  echo -e "Folder already exists.\n"
  echo -e "Installing..."
  theme
else
  mkdir -p "$HOME"/.local/share/themes
  echo -e "Installing..."
  theme
fi

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

if [ -d "$HOME"/.local/share/fonts ]
then
	wget  "$url_fantasque" -P "$HOME"/.local/share/fonts
else
	mkdir -p "$HOME"/.local/share/fonts
	wget  "$url_fantasque" -P "$HOME"/.local/share/fonts
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

wget -O /tmp/ubuntu.zip https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
unzip -qq /tmp/ubuntu.zip -d /tmp
sudo cp -a /tmp/ubuntu-font-family-0.83/*.ttf "$HOME"/.local/share/fonts
sudo fc-cache -f -v >/dev/null

sudo flatpak override --filesystem="xdg-data/themes:ro"
sudo flatpak override --filesystem="xdg-data/icons:ro"
gsettings set org.gnome.desktop.default-applications.terminal exec terminator
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'chromium.desktop', 'codium.desktop', 'appimagekit-joplin.desktop']"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### Finishing and cleaning.
sudo dnf autoremove -y

### Cleaning temporary download folder.
sudo rm "$directory_downloads"/ -rf
sudo systemctl daemon-reload
