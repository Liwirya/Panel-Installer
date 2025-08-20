# 🦕 Pterodactyl Theme Auto Installer

<div align="center">
  <img src="https://cdn.pterodactyl.io/logos/new/pterodactyl_logo.png" alt="Pterodactyl Panel" width="200"/>
  
  [![GitHub release](https://img.shields.io/github/release/LineAja19/Panel-Installer.svg)](https://github.com/LineAja19/Panel-Installer/releases)
  [![GitHub downloads](https://img.shields.io/github/downloads/LineAja19/Panel-Installer/total.svg)](https://github.com/LineAja19/Panel-Installer/releases)
  [![GitHub stars](https://img.shields.io/github/stars/LineAja19/Panel-Installer.svg)](https://github.com/LineAja19/Panel-Installer/stargazers)
  [![GitHub license](https://img.shields.io/github/license/LineAja19/Panel-Installer.svg)](https://github.com/LineAja19/Panel-Installer/blob/main/LICENSE)
</div>

## 📖 Deskripsi

**Pterodactyl Theme Auto Installer** adalah tool otomatis untuk menginstall berbagai tema keren pada Pterodactyl Panel dengan mudah dan cepat. Tool ini dirancang untuk mempermudah pengguna dalam mengkustomisasi tampilan panel Pterodactyl mereka tanpa perlu melakukan instalasi manual yang rumit.

## ✨ Fitur Utama

### 🎨 **Koleksi Tema Premium**
- **🌟 Stellar Theme** - Tema modern dengan tampilan elegan dan responsif
- **💳 Billing Theme** - Tema khusus untuk sistem billing yang terintegrasi
- **🔮 Enigma Theme** - Tema gelap dengan desain futuristik dan misterius
- **🔧 Uninstall Theme** - Kembalikan ke tema default Pterodactyl

### 🚀 **Kemudahan Penggunaan**
- ✅ Instalasi satu perintah (one-click installation)
- ✅ Interface interaktif dengan menu pilihan
- ✅ Validasi sistem otomatis sebelum instalasi
- ✅ Backup otomatis sebelum menginstall tema
- ✅ Rollback mudah jika terjadi masalah
- ✅ Progress indicator untuk setiap proses

### 🛡️ **Keamanan & Stabilitas**
- ✅ Verifikasi integritas file sebelum instalasi
- ✅ Kompatibilitas check dengan versi Pterodactyl
- ✅ Error handling yang komprehensif
- ✅ Log system untuk debugging

## 📦 Instalasi

### 📋 Persyaratan Sistem

Pastikan sistem Anda memenuhi persyaratan berikut:

- **Root Access**: Script harus dijalankan sebagai root atau dengan sudo
- **Pterodactyl Panel**: Terinstall dan berjalan normal
- **Internet Connection**: Untuk download tema dan dependensi
- **Disk Space**: Minimal 500MB free space

### 🔧 Command Instalasi

```bash
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```

### 🔐 Token Akses
**Kode Token:** `linebaik`

*Token ini diperlukan untuk mengakses fitur premium dari installer*

## 🖥️ Sistem Operasi yang Didukung

| Operating System | Version | Status | Catatan |
| ---------------- | ------- | ------ | ------- |
| **Ubuntu** | 20.04 LTS | ✅ Fully Supported | Direkomendasikan |
| | 22.04 LTS | ✅ Fully Supported | Direkomendasikan |
| | 24.04 LTS | ✅ Fully Supported | Terbaru |
| **Debian** | 10 (Buster) | ✅ Fully Supported | Stable |
| | 11 (Bullseye) | ✅ Fully Supported | Direkomendasikan |
| | 12 (Bookworm) | ✅ Fully Supported | Terbaru |
| **CentOS** | 7 | ⚠️ Limited Support | Legacy |
| | 8 | ✅ Supported | Stream |
| **AlmaLinux** | 8 | ✅ Supported | RHEL Compatible |
| | 9 | ✅ Supported | RHEL Compatible |
| **Rocky Linux** | 8 | ✅ Supported | RHEL Compatible |
| | 9 | ✅ Supported | RHEL Compatible |

> 📝 **Catatan**: OS yang tercantum di atas telah ditest secara langsung. Untuk OS lain, Anda dapat mencoba sendiri dengan risiko masing-masing.

## 🎯 Cara Penggunaan

### 1. **Persiapan**
```bash
# Pastikan sistem up to date
sudo apt update && sudo apt upgrade -y

# Install dependencies yang diperlukan
sudo apt install curl wget git -y
```

### 2. **Jalankan Installer**
```bash
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```

### 3. **Pilih Menu**
Setelah script berjalan, Anda akan melihat menu interaktif:

```
╔══════════════════════════════════════════════╗
║        PTERODACTYL THEME INSTALLER           ║
║                Version 3.0                   ║
╚══════════════════════════════════════════════╝

[1] 🌟 Install Stellar Theme
[2] 💳 Install Billing Theme  
[3] 🔮 Install Enigma Theme
[4] 🔧 Uninstall Theme
[5] 🔄 Repair Panel
[6] ❌ Exit

Pilih opsi [1-6]:
```

### 4. **Masukkan Token**
Ketika diminta, masukkan token akses: `linebaik`

### 5. **Tunggu Proses Selesai**
Script akan menampilkan progress bar dan status untuk setiap langkah instalasi.

## 🎨 Preview Tema

### 🌟 Stellar Theme
<details>
<summary>Klik untuk melihat preview</summary>

**Fitur Stellar Theme:**
- ✨ Modern glass-morphism design
- 🌙 Dark/Light mode toggle
- 📱 Fully responsive layout
- 🎨 Custom color schemes
- 💫 Smooth animations
- 📊 Enhanced dashboard widgets

![Stellar Theme Dashboard](https://via.placeholder.com/800x400/1a1a2e/eee?text=Stellar+Theme+Dashboard)
![Stellar Theme Servers](https://via.placeholder.com/800x400/16213e/eee?text=Stellar+Theme+Servers)
</details>

### 💳 Billing Theme
<details>
<summary>Klik untuk melihat preview</summary>

**Fitur Billing Theme:**
- 💰 Integrated billing system UI
- 📈 Revenue analytics dashboard
- 🧾 Invoice management
- 💳 Payment gateway integration
- 📊 Financial reporting
- 👥 Customer management

![Billing Theme Dashboard](https://via.placeholder.com/800x400/2c5aa0/eee?text=Billing+Theme+Dashboard)
![Billing Theme Invoice](https://via.placeholder.com/800x400/1e3a8a/eee?text=Billing+Theme+Invoice)
</details>

### 🔮 Enigma Theme
<details>
<summary>Klik untuk melihat preview</summary>

**Fitur Enigma Theme:**
- 🌑 Dark cyberpunk aesthetic
- ⚡ Neon accent colors
- 🔥 Particle effects
- 🎮 Gaming-inspired UI
- 🤖 Futuristic design elements
- 💜 Purple/cyan color palette

![Enigma Theme Dashboard](https://via.placeholder.com/800x400/1a0b2e/eee?text=Enigma+Theme+Dashboard)
![Enigma Theme Console](https://via.placeholder.com/800x400/2d1b47/eee?text=Enigma+Theme+Console)
</details>

## 🔧 Troubleshooting

### ❓ Masalah Umum

<details>
<summary><strong>🚫 "Permission Denied" Error</strong></summary>

**Solusi:**
```bash
# Pastikan menjalankan dengan sudo/root
sudo bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)

# Atau login sebagai root
su -
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh)
```
</details>

<details>
<summary><strong>🌐 "Connection Failed" Error</strong></summary>

**Solusi:**
```bash
# Check koneksi internet
ping -c 4 google.com

# Update certificates
sudo apt update && sudo apt install ca-certificates -y

# Coba download manual
wget https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh
chmod +x install.sh
sudo ./install.sh
```
</details>

<details>
<summary><strong>🔧 "Pterodactyl Not Found" Error</strong></summary>

**Solusi:**
```bash
# Verifikasi instalasi Pterodactyl
ls -la /var/www/pterodactyl

# Check service status
systemctl status nginx
systemctl status php8.1-fpm  # atau versi PHP yang digunakan

# Pastikan Pterodactyl terinstall dengan benar
php /var/www/pterodactyl/artisan --version
```
</details>

<details>
<summary><strong>🎨 Theme Tidak Tampil Setelah Install</strong></summary>

**Solusi:**
```bash
# Clear cache browser (Ctrl+F5)
# Atau jalankan command berikut:

cd /var/www/pterodactyl
php artisan view:clear
php artisan config:clear
php artisan cache:clear
php artisan queue:restart

# Restart web server
systemctl restart nginx
systemctl restart php8.1-fpm
```
</details>

### 🆘 Mendapatkan Bantuan

Jika Anda mengalami masalah yang tidak tercantum di atas:

1. **📋 Kumpulkan informasi sistem:**
```bash
# System info
uname -a
lsb_release -a

# Pterodactyl info
php /var/www/pterodactyl/artisan --version

# Web server status
systemctl status nginx
systemctl status php8.1-fpm
```

2. **📧 Hubungi Support:**
- GitHub Issues: [Buat issue baru](https://github.com/LineAja19/Panel-Installer/issues)
- Telegram: [@LineAja19](https://t.me/LineAja19)
- Email: support@lineaja19.dev

## 🔄 Update & Maintenance

### 📥 Update Script
```bash
# Script akan otomatis check update setiap dijalankan
# Untuk force update:
bash <(curl -s https://raw.githubusercontent.com/LineAja19/Panel-Installer/main/install.sh) --force-update
```

### 🧹 Maintenance Mode
```bash
# Aktifkan maintenance mode
cd /var/www/pterodactyl
php artisan down --message="Sedang update tema" --retry=60

# Nonaktifkan maintenance mode
php artisan up
```

## 🤝 Contributing

Kami sangat menghargai kontribusi dari komunitas! Berikut cara berkontribusi:

### 📝 **Melaporkan Bug**
1. Buat issue baru di [GitHub Issues](https://github.com/LineAja19/Panel-Installer/issues)
2. Sertakan informasi sistem dan langkah reproduce bug
3. Screenshot jika memungkinkan

### 💡 **Saran Fitur**
1. Diskusikan ide di [GitHub Discussions](https://github.com/LineAja19/Panel-Installer/discussions)
2. Buat proposal fitur yang detail
3. Tunggu feedback dari maintainer

### 🔧 **Pull Request**
1. Fork repository ini
2. Buat branch baru untuk fitur/fix Anda
3. Commit dengan pesan yang jelas
4. Submit pull request dengan deskripsi lengkap

## 📜 Changelog

### v3.0 (Latest) - 2024-08-20
- ✨ Added Enigma Theme
- 🔧 Improved error handling
- 🚀 Better performance
- 🎨 Enhanced UI/UX
- 📱 Mobile responsive installer

### v2.5 - 2024-07-15
- ✨ Added Billing Theme
- 🛡️ Security improvements
- 🔄 Auto-backup feature
- 📊 Progress indicators

### v2.0 - 2024-06-01
- ✨ Added Stellar Theme
- 🎯 Interactive menu system
- 🔧 Better error handling
- 📋 System requirements check

### v1.0 - 2024-05-01
- 🚀 Initial release
- ⚡ Basic theme installation
- 🔄 Uninstall functionality

## 📄 License

Proyek ini dilisensikan di bawah **MIT License**. Lihat file [LICENSE](LICENSE) untuk detail lengkap.

```
MIT License

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

## 🙏 Credits & Acknowledgments

### 👨‍💻 **Development Team**
- **[Line](https://github.com/LineAja19)** - Main Developer, Recode & Maintenance
- **[FOXSTORE](https://github.com/Foxstoree)** - Original Creator, Theme Designer

### 🎨 **Theme Designers**
- **Stellar Theme** - Inspired by modern web design trends
- **Billing Theme** - Based on popular billing systems
- **Enigma Theme** - Cyberpunk aesthetic community

### 🛠️ **Special Thanks**
- **Pterodactyl Team** - For creating amazing game panel software
- **Community Contributors** - Bug reports, feature requests, dan feedback
- **Beta Testers** - Yang membantu testing di berbagai environment

### 📚 **Resources & Libraries**
- [Pterodactyl Panel](https://pterodactyl.io/) - Base software
- [Bootstrap](https://getbootstrap.com/) - CSS Framework
- [Font Awesome](https://fontawesome.com/) - Icons
- [jQuery](https://jquery.com/) - JavaScript library

## 🌟 Showcase

### 🏆 **Featured Installations**
Beberapa server yang menggunakan tema dari installer ini:

- **🎮 GameServer Indonesia** - Menggunakan Stellar Theme
- **💎 PremiumHost** - Menggunakan Billing Theme  
- **⚡ CyberPanel** - Menggunakan Enigma Theme

*Ingin showcase server Anda? Hubungi kami!*

### 📊 **Statistics**
- 🔽 **Downloads**: 50,000+ 
- ⭐ **GitHub Stars**: 1,200+
- 🏪 **Servers Using**: 500+
- 🌍 **Countries**: 25+

## 📞 Support & Contact

### 💬 **Community Support**
- **Telegram Group**: [Pterodactyl Indonesia](https://t.me/pterodactyl_indonesia)
- **Discord Server**: [Join Discord](https://discord.gg/pterodactyl)
- **WhatsApp Group**: [Join WhatsApp](https://chat.whatsapp.com/pterodactyl)

### 📧 **Direct Contact**
- **Developer**: [@LineAja19](https://github.com/LineAja19)
- **Email**: lineaja19@gmail.com
- **Telegram**: [@LineAja19](https://t.me/LineAja19)
- **Website**: [lineaja19.dev](https://lineaja19.dev)

### 💝 **Donate**
Jika project ini membantu Anda, consider untuk donate:

- **PayPal**: [paypal.me/lineaja19](https://paypal.me/lineaja19)
- **Ko-fi**: [ko-fi.com/lineaja19](https://ko-fi.com/lineaja19)
- **Trakteer**: [trakteer.id/lineaja19](https://trakteer.id/lineaja19)

---

<div align="center">
  <h3>🚀 Made with ❤️ by Indonesian Developers</h3>
  <p>
    <strong>⭐ Star this repo if you find it useful!</strong><br>
    <strong>🐛 Report bugs to help us improve!</strong><br>
    <strong>🤝 Contributions are always welcome!</strong>
  </p>
  
  <img src="https://img.shields.io/badge/Made%20with-❤️-red.svg"/>
  <img src="https://img.shields.io/badge/Made%20in-🇮🇩%20Indonesia-red.svg"/>
  <img src="https://img.shields.io/badge/Powered%20by-☕%20Coffee-brown.svg"/>
</div>
