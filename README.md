# 🚀 Pterodactyl Installer

<div align="center">

![Pterodactyl Logo](https://cdn.pterodactyl.io/logos/Banner%20Logo%20Black@2x.png)

  <img src="https://img.shields.io/badge/Pterodactyl-Panel-blue?style=for-the-badge&logo=pterodactyl" alt="Pterodactyl Panel">
  <img src="https://img.shields.io/badge/Version-2.0-brightgreen?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/Language-Bahasa%20Indonesia-red?style=for-the-badge" alt="Language">
</div>

## 📋 Deskripsi

Tools ini dimana digunakan / membantu user dalam penginstallan panel ptreodactyl dan juga dapat mengembalikan / memperbaiki error ketika terjadi keselahan proses atau instalisasi

## ⚡ Command

```bash
bash <(curl -s https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/install.sh)
```

> **Catatan:** Pastikan dalam menjalankan command di atas wajib dengan vps atau menggunakan `sudo`

### 🛠️ Fitur Unggupan
- 🔧 **Instalasi Otomatis** - Install Panel Ptreodactyl secara otomatis
- 🗑️ **Uninstall Tema** - Kembalikan ke tema default Pterodactyl
- 🔐 **System Keamanan** - Menggunakan token akses untuk keamanan
- 📊 **Progress Indicator** - Menampilkan progress instalasi
- ⚠️ **Error Handling** - Penanganan error yang baik
- 💾 **Backup Otomatis** - Backup tema sebelumnya (opsional)

## 🔑 Kode Akses

```
Token: Liwirya2025
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
bash <(curl -s https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/install.sh)
```

### 3. Ikuti Menu Interaktif
- Pilih tema yang ingin diinstall
- Masukkan kode token: `Liwirya2025`
- Tunggu proses instalasi selesai
- Refresh browser untuk melihat tema baru yg udh diinstall

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
bash <(curl -s https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/repair.sh)
```

## 📞 Support & Bantuan

### 🆘 Butuh Bantuan?
- 📧 **Email:** wiraliwirya@gmail.com
- 🐛 **Bug Report:** [GitHub Issues](https://github.com/Liwirya/Panel-Installer/issues)

### 🤝 Kontribusi
Kami menerima kontribusi dari kalian! Silakan:
- Fork repository ini
- Buat branch baru untuk fitur/bugfix
- Submit pull request dengan deskripsi yang jelas

## 📄 Lisensi & Credits

### 👨‍💻 Developer
- **Creator:** [Liwirya](https://github.com/Liwirya) 👨‍💻
- **Community Contributors:** [Lihat semua](https://github.com/Liwirya/Panel-Installer/contributors)

### 📜 Lisensi
```
MIT License - Open Source Project
Copyright (c) 2025 Liwirya

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

Jika project ini membantu Anda, berikan bintang di GitHub dan share ke teman teman!

### 💖 Donasi
- **Trakteer:** [Trakteer Saya](https://trakteer.id/liwirya)

---

<div align="center">
  <strong>🚀 Made by Liwirya</strong><br>
</div>

---

## 📈 Statistics

<div align="center">
  <img src="https://img.shields.io/github/downloads/Liwirya/Panel-Installer/total?style=for-the-badge&color=blue" alt="Total Downloads">
  <img src="https://img.shields.io/github/stars/Liwirya/Panel-Installer?style=for-the-badge&color=yellow" alt="GitHub Stars">
  <img src="https://img.shields.io/github/forks/Liwirya/Panel-Installer?style=for-the-badge&color=green" alt="GitHub Forks">
  <img src="https://img.shields.io/github/issues/Liwirya/Panel-Installer?style=for-the-badge&color=red" alt="GitHub Issues">
</div>
