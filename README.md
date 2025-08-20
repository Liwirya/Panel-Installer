# 🚀 Pterodactyl Theme Auto Installer

<div align="center">
  <img src="https://img.shields.io/badge/Pterodactyl-Panel-blue?style=for-the-badge&logo=pterodactyl" alt="Pterodactyl Panel">
  <img src="https://img.shields.io/badge/Version-2.0-brightgreen?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/Language-Bahasa%20Indonesia-red?style=for-the-badge" alt="Language">
</div>

## 📋 Deskripsi

Tool otomatis untuk menginstall berbagai tema Pterodactyl Panel dengan mudah dan cepat. Script ini mendukung instalasi berbagai tema populer dan menyediakan fitur uninstall untuk mengembalikan panel ke kondisi default.

## ⚡ Instalasi Cepat

```bash
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```

> **Catatan:** Pastikan menjalankan command di atas sebagai user root atau menggunakan `sudo`

## 🎨 Fitur Tema Yang Tersedia

### ✨ Tema Premium
| Nama Tema | Deskripsi | Status |
|-----------|-----------|--------|
| **Stellar** | Tema modern dengan dark mode | ✅ Tersedia |
| **Billing** | Tema khusus untuk billing system | ✅ Tersedia |
| **Enigma** | Tema elegan dengan animasi smooth | ✅ Tersedia |

### 🛠️ Fitur Tambahan
- 🔧 **Instalasi Otomatis** - Install tema dengan satu klik
- 🗑️ **Uninstall Tema** - Kembalikan ke tema default Pterodactyl
- 🔐 **System Keamanan** - Menggunakan token akses untuk keamanan
- 📊 **Progress Indicator** - Menampilkan progress instalasi
- ⚠️ **Error Handling** - Penanganan error yang baik
- 💾 **Backup Otomatis** - Backup tema sebelumnya (opsional)

## 🔑 Kode Akses

```
Token: linebaik
```

> **Penting:** Kode token diperlukan untuk mengakses installer. Pastikan memasukkan token yang benar.

## 🖥️ Sistem Yang Didukung

| Sistem Operasi | Versi | Status Dukungan |
| -------------- | ----- | --------------- |
| **Ubuntu** | 20.04 LTS | ✅ Fully Supported |
| | 22.04 LTS | ✅ Fully Supported |
| **Debian** | 10 (Buster) | ✅ Fully Supported |
| | 11 (Bullseye) | ✅ Fully Supported |
| | 12 (Bookworm) | ✅ Fully Supported |
| **CentOS** | 7 | ⚠️ Limited Support |
| | 8 | ⚠️ Limited Support |

> **Catatan:** Sistem operasi di atas telah ditest secara langsung. Untuk OS lain, silakan test sendiri atau hubungi developer.

## 📦 Prasyarat Sistem

Pastikan sistem Anda memenuhi requirements berikut:

- ✅ **Pterodactyl Panel** sudah terinstall dan berjalan
- ✅ **Root Access** atau sudo privileges
- ✅ **Internet Connection** untuk download tema
- ✅ **PHP** versi 8.0 atau lebih tinggi
- ✅ **Composer** terinstall dan dapat diakses
- ✅ **Web Server** (Nginx/Apache) berjalan normal

## 🚀 Cara Penggunaan

### 1. Persiapan
```bash
# Pastikan Pterodactyl Panel berjalan normal
sudo systemctl status pterodactyl

# Update sistem (opsional tapi disarankan)
sudo apt update && sudo apt upgrade -y
```

### 2. Jalankan Installer
```bash
# Download dan jalankan script
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```

### 3. Ikuti Menu Interaktif
- Pilih tema yang ingin diinstall
- Masukkan kode token: `linebaik`
- Tunggu proses instalasi selesai
- Refresh browser untuk melihat tema baru

### 4. Uninstall Tema (jika diperlukan)
- Jalankan script lagi
- Pilih opsi "Uninstall Tema"
- Konfirmasi untuk mengembalikan ke tema default

## 🔧 Troubleshooting

### Masalah Umum dan Solusi

| Masalah | Solusi |
|---------|--------|
| **Permission denied** | Jalankan sebagai root: `sudo bash install.sh` |
| **Tema tidak muncul** | Clear cache browser dan refresh halaman |
| **Error 500** | Periksa log: `tail -f /var/log/nginx/error.log` |
| **Database error** | Jalankan: `php artisan migrate --force` |
| **File permission** | Reset permission: `chown -R www-data:www-data /var/www/pterodactyl` |

### Command Berguna
```bash
# Cek status Pterodactyl
sudo systemctl status pterodactyl

# Restart web server
sudo systemctl restart nginx  # atau apache2

# Clear cache aplikasi
cd /var/www/pterodactyl && php artisan cache:clear

# Repair panel jika bermasalah
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/repair.sh)
```

## 📸 Preview Tema

### 🌟 Stellar Theme
- Design modern dengan dark mode elegant
- Responsive di semua device
- Animasi smooth dan user-friendly

### 💰 Billing Theme
- Optimized untuk sistem billing
- Dashboard yang clean dan professional
- Integration dengan payment gateway

### 🔮 Enigma Theme
- Tampilan futuristik dengan efek glassmorphism
- Color scheme yang eye-catching
- Perfect untuk gaming server

## 📞 Support & Bantuan

### 🆘 Butuh Bantuan?
- 💬 **Discord:** [Join Server](https://discord.gg/your-server)
- 📧 **Email:** support@lineaja19.com
- 🐛 **Bug Report:** [GitHub Issues](https://github.com/LineAja19/Panel-Installer/issues)
- 📚 **Dokumentasi:** [Wiki Page](https://github.com/LineAja19/Panel-Installer/wiki)

### 🤝 Kontribusi
Kami menerima kontribusi dari komunitas! Silakan:
- Fork repository ini
- Buat branch baru untuk fitur/bugfix
- Submit pull request dengan deskripsi yang jelas

## 📄 Lisensi & Credits

### 👨‍💻 Developer
- **Recode & Maintain by:** [Line](https://github.com/LineAja19) ⭐
- **Original Creator:** [FOXSTORE](https://github.com/Foxstoree) 🦊
- **Community Contributors:** [View All](https://github.com/LineAja19/Panel-Installer/contributors)

### 📜 Lisensi
```
MIT License - Open Source Project
Copyright (c) 2024 LineAja19

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## ⭐ Dukung Project Ini

Jika project ini membantu Anda, berikan ⭐ di GitHub dan share ke teman-teman!

### 💖 Donasi
- **PayPal:** [Donate Here](https://paypal.me/lineaja19)
- **Ko-fi:** [Buy Me Coffee](https://ko-fi.com/lineaja19)
- **Trakteer:** [Trakteer Saya](https://trakteer.id/lineaja19)

---

<div align="center">
  <strong>🚀 Made with ❤️ by Indonesian Developers 🇮🇩</strong><br>
  <em>For the Pterodactyl Community Worldwide 🌍</em>
</div>

---

## 📈 Statistics

<div align="center">
  <img src="https://img.shields.io/github/downloads/LineAja19/Panel-Installer/total?style=for-the-badge&color=blue" alt="Total Downloads">
  <img src="https://img.shields.io/github/stars/LineAja19/Panel-Installer?style=for-the-badge&color=yellow" alt="GitHub Stars">
  <img src="https://img.shields.io/github/forks/LineAja19/Panel-Installer?style=for-the-badge&color=green" alt="GitHub Forks">
  <img src="https://img.shields.io/github/issues/LineAja19/Panel-Installer?style=for-the-badge&color=red" alt="GitHub Issues">
</div>- **📊 Progress Tracking** - Real-time installation progress
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
