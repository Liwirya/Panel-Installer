# 🚀 Pterodactyl Installer

> Instal atau kembalikan tema Pterodactyl Panel dengan satu perintah.

## 🔧 Perintah Instalasi
```bash
sudo bash <(curl -s https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/install.sh)
```
> ⚠️ Harus dijalankan di **VPS** sebagai **root** atau pakai `sudo`.

---

## ✅ OS yang Didukung
| OS       | Versi               | Status        |
|----------|---------------------|---------------|
| Ubuntu   | 20.04, 22.04        | ✅ Full       |
| Debian   | 10, 11, 12          | ✅ Full       |
| CentOS   | 7, 8                | ⚠️ Terbatas   |

---

## 📋 Langkah Penggunaan
1. **Pastikan panel jalan**:
   ```bash
   sudo systemctl status pterodactyl
   ```
2. **Jalankan installer**:
   ```bash
   sudo bash <(curl -s https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/install.sh)
   ```
3. **Pilih opsi**:
   - Install tema → masukkan token → tunggu → refresh browser.
   - Uninstall tema → kembalikan ke default.

---

## 🛠️ Troubleshooting Cepat

| Masalah                 | Solusi |
|------------------------|--------|
| Permission denied      | Gunakan `sudo` |
| Tema tidak muncul      | Clear cache browser |
| Error 500              | Cek log: `tail -f /var/log/nginx/error.log` |
| Database error         | Jalankan: `cd /var/www/pterodactyl && php artisan migrate --force` |
| File permission salah  | `chown -R www-data:www-data /var/www/pterodactyl` |

### Perintah Darurat
```bash
# Restart panel
sudo systemctl restart pterodactyl

# Clear cache
cd /var/www/pterodactyl && php artisan cache:clear

# Perbaiki panel
bash <(curl -s https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/repair.sh)
```

---

## 📞 Bantuan
- Email: wiraliwirya@gmail.com  
- Laporkan bug: [GitHub Issues](https://github.com/Liwirya/Panel-Installer/issues)

---

> 💡 **Tips**: Selalu backup sebelum ganti tema!  
> 🚀 **Donasi**: [Trakteer Saya](https://trakteer.id/liwiryadev_idn)
