# Pos Install Scripts

<p align="center">
    <img alt="License" src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge">
    <img alt="Shell Script" src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white">
    <img alt="Makefile" src="https://img.shields.io/badge/Make-121011?logo=make&logoColor=fff&style=for-the-badge">
    <img alt="Fedora" src="https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=fff&style=for-the-badge">
</p>

This script was developed with the aim of demonstrating post-installation and parameterization of my PC with **Fedora**. The aim is to build a "minimal" installation and customize it as needed, with app installations only via terminal.

> [!WARNING]\
> It is entirely free to copy and execute the scripts contained in this repository, however, you must **read and understand** what each step does. If you choose to execute it fully, knowing that my usage profile is certainly different from yours, or **adapt it (best option) to your needs** before execution modifying programs that will be installed in the repository stages, .rpm, Flatpak, Codium extensions. 
> 
> The aim in addition to demonstrating is to serve as inspiration for building **your own post-installation script**.

> [!CAUTION]\
> **Disclaimer:** The scripts made available are certainly **tested by me** before being published, however due to the nature of the difference between hardware and the period when script updates and system and package updates occur, errors may occur during execution. Therefore, **there are no full guarantees of the full functioning of this script** so **I will not be responsible if there is any material damage or loss of data**.
> 
> I **kindly** ask that in case of errors report them in the [Issues tab](https://github.com/ciro-mota/Meu-Pos-Instalacao/issues) and I will try as much as possible to help.

### 🔧 GNOME Extensions

- [AppIndicator and KStatusNotifierItem Support](https://packages.fedoraproject.org/pkgs/gnome-shell-extension-appindicator/gnome-shell-extension-appindicator/)
- [Bluetooth Battery Meter](https://extensions.gnome.org/extension/6670/bluetooth-battery-meter/)
- [Date Menu Formatter](https://extensions.gnome.org/extension/4655/date-menu-formatter/) (SimpleDateFormat - String: dd MMMM y | k:mm)
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [Desktop Icons NG (DING)](https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/)
- [Hide Activities Button](https://extensions.gnome.org/extension/744/hide-activities-button/)
- [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
- [Steal my focus window](https://extensions.gnome.org/extension/6385/steal-my-focus-window/)
- [Vitals](https://extensions.gnome.org/extension/1460/vitals/)
- [Window title is back](https://extensions.gnome.org/extension/6310/window-title-is-back/)

### ⚫ Dots

There is also a folder called `confs` in which some configuration files are hosted and imported when running the script and contains my configurations for `Terminator`, `fastfetch`, `Starship` and `micro`. Other apps should be added in the future.

### 💻 Final appearance

![](imgs/screenshot.webp)

### 📅 Last modified

> 11 Apr 2025
