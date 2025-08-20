# 🦅 Pterodactyl Theme Autoinstaller

<div align="center">

![Pterodactyl Logo](https://cdn.pterodactyl.io/logos/Banner%20Logo%20Black@2x.png)

[![GitHub release](https://img.shields.io/github/v/release/LineAja19/Panel-Installer?style=for-the-badge)](https://github.com/LineAja19/Panel-Installer/releases)
[![GitHub stars](https://img.shields.io/github/stars/LineAja19/Panel-Installer?style=for-the-badge)](https://github.com/LineAja19/Panel-Installer/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/LineAja19/Panel-Installer?style=for-the-badge)](https://github.com/LineAja19/Panel-Installer/issues)
[![License](https://img.shields.io/github/license/LineAja19/Panel-Installer?style=for-the-badge)](https://github.com/LineAja19/Panel-Installer/blob/main/LICENSE)

**🚀 One-command solution to transform your Pterodactyl Panel with beautiful themes**

[Installation](#-quick-installation) • [Features](#-features) • [Themes](#-available-themes) • [Support](#-system-requirements) • [Contributing](#-contributing)

</div>

---

## 🎯 Overview

Pterodactyl Theme Autoinstaller is a powerful automation tool that allows you to easily install, manage, and switch between different themes for your Pterodactyl Game Panel. With a single command, you can completely transform the look and feel of your panel.

## 📦 Quick Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```

> **⚠️ Important:** Run this command as root or with sudo privileges

## ✨ Features

### 🎨 **Theme Management**
- **🌟 Stellar Theme** - Modern and sleek design with dark mode support
- **💰 Billing Theme** - Professional billing-focused interface
- **🔮 Enigma Theme** - Mysterious and elegant dark theme
- **🔄 Theme Switching** - Easily switch between installed themes
- **🗑️ Theme Removal** - Clean uninstallation of themes

### 🛠️ **Advanced Tools**
- **📋 Interactive Menu** - User-friendly command-line interface
- **🔍 Auto-Detection** - Automatically detects Pterodactyl installation
- **🛡️ Backup System** - Creates backups before theme installation
- **⚡ Fast Installation** - Optimized installation process
- **🔧 Repair Tools** - Built-in panel repair functionality

### 🔐 **Security & Reliability**
- **✅ Validation Checks** - Ensures system compatibility
- **🔒 Secure Downloads** - Verified theme sources
- **📊 Progress Tracking** - Real-time installation progress
- **🚨 Error Handling** - Comprehensive error management

## 🎨 Available Themes

<div align="center">

| Theme | Preview | Description | Status |
|-------|---------|-------------|--------|
| **Stellar** | ![Stellar Preview](https://via.placeholder.com/200x100?text=Stellar+Theme) | Modern, clean interface with responsive design | ✅ Active |
| **Billing** | ![Billing Preview](https://via.placeholder.com/200x100?text=Billing+Theme) | Professional billing and invoice management | ✅ Active |
| **Enigma** | ![Enigma Preview](https://via.placeholder.com/200x100?text=Enigma+Theme) | Dark, mysterious design with advanced UI elements | ✅ Active |

</div>

## 🖥️ System Requirements

### ✅ Supported Operating Systems

| Operating System | Version | Support Level | Status |
|------------------|---------|---------------|--------|
| **Ubuntu** | 20.04 LTS | ✅ Full Support | Tested |
| **Ubuntu** | 22.04 LTS | ✅ Full Support | Tested |
| **Ubuntu** | 24.04 LTS | ✅ Full Support | Tested |
| **Debian** | 10 (Buster) | ✅ Full Support | Tested |
| **Debian** | 11 (Bullseye) | ✅ Full Support | Tested |
| **Debian** | 12 (Bookworm) | ✅ Full Support | Tested |
| **CentOS** | 7/8/9 | 🔶 Experimental | Community |
| **RHEL** | 8/9 | 🔶 Experimental | Community |

> **💡 Note:** While we officially test on Ubuntu and Debian, the installer may work on other Linux distributions. Feel free to test and report issues!

### 📋 Prerequisites

- **Pterodactyl Panel** v1.6+ installed and running
- **Root/Sudo access** to the server
- **Internet connection** for downloading themes
- **PHP 8.1+** with required extensions
- **Web server** (Apache/Nginx) properly configured

## 🚀 Usage Guide

### 1️⃣ **Initial Setup**
```bash
# Download and run the installer
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```

### 2️⃣ **Authentication**
When prompted, enter the access token: `linebaik`

### 3️⃣ **Choose Your Action**
- **Install Theme** - Select from available themes
- **Switch Theme** - Change between installed themes  
- **Uninstall Theme** - Remove theme and restore default
- **Repair Panel** - Fix common panel issues

### 4️⃣ **Follow Instructions**
The installer will guide you through each step with clear prompts and progress indicators.

## 🔧 Advanced Configuration

### 🎛️ **Manual Configuration**
After installation, you can manually customize themes by editing:
```bash
/var/www/pterodactyl/resources/views/
/var/www/pterodactyl/public/themes/
```

### 🔄 **Theme Switching**
```bash
# Switch themes without reinstalling
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/switch.sh)
```

### 🛠️ **Panel Repair**
```bash
# Repair panel if themes cause issues
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/repair.sh)
```

## 🐛 Troubleshooting

<details>
<summary><strong>🔍 Common Issues & Solutions</strong></summary>

### **Installation Fails**
```bash
# Check Pterodactyl installation
php artisan --version

# Verify permissions
ls -la /var/www/pterodactyl/
```

### **Theme Not Loading**
```bash
# Clear caches
php artisan view:clear
php artisan config:clear
php artisan cache:clear
```

### **Permission Errors**
```bash
# Fix ownership
chown -R www-data:www-data /var/www/pterodactyl/
chmod -R 755 /var/www/pterodactyl/
```

### **Restore Default Theme**
```bash
# Use the uninstall option in the main script
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
# Select "Uninstall Theme"
```

</details>

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🎨 **Submit New Themes**
1. Fork the repository
2. Create a new theme directory
3. Add installation scripts
4. Submit a pull request

### 🐛 **Report Issues**
- Use GitHub Issues for bug reports
- Include system information and error logs
- Provide steps to reproduce

### 📝 **Documentation**
- Help improve this README
- Add translations
- Create video tutorials

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Credits & Acknowledgments

<div align="center">

### 🏆 **Main Contributors**
| Role | Contributor | GitHub |
|------|-------------|---------|
| **Recode & Maintenance** | Line | [@LineAja19](https://github.com/LineAja19) |
| **Original Creator** | FOXSTORE | [@Foxstoree](https://github.com/Foxstoree) |

### 🙏 **Special Thanks**
- **Pterodactyl Team** - For the amazing panel software
- **Community Contributors** - For testing and feedback
- **Theme Designers** - For beautiful theme creations

</div>

## 🌟 Support This Project

If this tool helped you, consider:

- ⭐ **Star this repository**
- 🐛 **Report issues** you encounter
- 🎨 **Contribute new themes**
- 📢 **Share with others**

---

<div align="center">

**Made with ❤️ for the Pterodactyl community**

[⬆️ Back to Top](#-pterodactyl-theme-autoinstaller)

</div>
