# 🛠️ Panduan Build Lokal AutoXV-v1 via VS Code (Tanpa Error)

Panduan ini dibuat khusus untuk menyelesaikan masalah build yang Anda temui pada perangkat Windows Anda.

---

## 🔍 Analisis Error yang Anda Alami

### 1. Masalah Pertama: `JAVA_HOME is set to an invalid directory`
*   **Penyebab:** Anda mengarahkan `JAVA_HOME` ke `C:\ProgramData\Oracle\Java\javapath`. Folder ini **bukan** folder instalasi JDK (Java Development Kit) asli, melainkan folder pintasan (*symlink*) berisi file `java.exe` saja. Gradle membutuhkan compiler Java (`javac.exe`) yang hanya ada di dalam folder instalasi JDK penuh.
*   **Solusi:** Kita harus mengarahkan `JAVA_HOME` ke folder JDK yang asli (seperti `C:\Program Files\Eclipse Adoptium\jdk-17...` atau `C:\Program Files\Java\jdk-17...`).

### 2. Masalah Kedua: `Invalid or corrupt jarfile gradle-wrapper.jar`
*   **Penyebab:** Ketika Anda mengunduh project sebagai file `.zip` dari cloud, beberapa file binary seperti `.jar` atau `.png` dapat berubah menjadi **Git LFS Pointer** (file teks berukuran kecil, sekitar 130 bytes, yang berisi alamat unduhan) dan bukan file `.jar` asli.
*   **Mengapa `Invoke-WebRequest` Anda menghasilkan "no main manifest attribute"?** Karena URL mentah GitHub (`raw.githubusercontent.com`) untuk file LFS juga hanya mengembalikan file teks pointer tersebut, bukan file binary asli! Saat Java mencoba menjalankannya, Java mendeteksi tidak ada kode di dalamnya.
*   **Solusi:** Mengunduh file `.jar` asli langsung dari server **Maven Central** resmi (`repo1.maven.org`) yang bebas dari Git LFS dan dijamin merupakan binary asli berukuran sekitar 50-60 KB.

---

## 🚀 Fitur Otomatis Baru di `build-apk.bat`

Saya telah memperbarui file `build-apk.bat` dengan fitur **Self-Healing & Auto-Config**:
1.  **Deteksi & Perbaikan Otomatis `gradle-wrapper.jar`:** Jika script mendeteksi file `.jar` Anda rusak/berukuran < 5KB (Pointer LFS), script akan otomatis mengunduh file binary asli dari Maven Central menggunakan PowerShell di latar belakang.
2.  **Pencarian JDK Otomatis:** Script akan memindai folder standar Windows Anda secara otomatis untuk mencari JDK 17 atau JDK 21 yang valid, sehingga Anda tidak perlu repot menyetel `JAVA_HOME` secara manual jika JDK sudah terinstal di folder standar.

---

## 📋 Langkah Langkah Menyiapkan Komputer Anda (Sekali Saja)

Ikuti langkah-langkah mudah berikut agar build di VS Code berjalan 100% lancar:

### Langkah 1: Instal JDK 17 Asli (Sangat Mudah)
Gunakan perintah otomatis Windows (*winget*) berikut melalui **PowerShell/CMD** (jalankan sebagai Administrator jika memungkinkan):

```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

*Atau jika Anda ingin unduh manual via browser:*
Download installer `.msi` dari [Adoptium Temurin JDK 17](https://adoptium.net/temurin/releases/?version=17) dan instal seperti biasa.

---

### Langkah 2: Cara Menjalankan Build di VS Code

Setelah JDK terinstal, silakan **tutup VS Code** Anda terlebih dahulu lalu **buka kembali** (ini wajib agar Windows membaca perubahan Environment PATH yang baru).

Ada 3 cara mudah untuk melakukan build di lokal:

#### Opsi A: Menggunakan File Klik Ganda (Paling Praktis)
1.  Buka File Explorer di Windows Anda.
2.  Klik ganda file `build-apk.bat` yang ada di folder root project.
3.  Script akan otomatis mendeteksi JDK Anda, memperbaiki `gradle-wrapper.jar` jika rusak, dan mulai membangun APK.

#### Opsi B: Menggunakan Task VS Code (Integrasi Penuh)
1.  Buka project di VS Code.
2.  Tekan tombol keyboard `Ctrl + Shift + B`.
3.  Pilih **`Build Debug APK (AutoXV)`**.
4.  VS Code akan otomatis menjalankan proses kompilasi langsung di terminal editor Anda.

#### Opsi C: Menggunakan Perintah Terminal (Manual)
Buka Terminal di VS Code (tekan ``Ctrl + ` ``) lalu ketik:

```powershell
.\build-apk.bat
```

---

## 📦 Di mana File APK Saya?

Setelah proses kompilasi selesai dengan sukses, file APK Anda akan tersimpan di:
📂 **`app\build\outputs\apk\debug\app-debug.apk`**

---

## 📲 Cara Instal di HP Android (Tanpa Kabel USB)

Karena Anda ingin menginstal secara gratis dan tanpa kabel USB, ikuti metode pengiriman nirkabel super cepat ini:

1.  **WhatsApp Web / Telegram Desktop:**
    *   Kirim file `app-debug.apk` dari komputer Anda melalui chat WhatsApp Web (kirim ke nomor Anda sendiri atau grup pribadi) atau Telegram.
    *   Buka WhatsApp/Telegram di HP Android Anda, unduh file APK tersebut, lalu ketuk untuk menginstal langsung.
2.  **Google Drive / Cloud Storage:**
    *   Upload file `app-debug.apk` ke Google Drive Anda dari komputer.
    *   Buka aplikasi Google Drive di HP Android, cari file tersebut, dan klik pasang/instal.
3.  **Koneksi Lokal (Bluetooth / ShareIt):**
    *   Kirim file langsung dari PC ke HP Anda via Bluetooth.

*Catatan: Saat pertama kali menginstal APK yang dibuat sendiri, Android akan memunculkan peringatan "Install dari Sumber Tidak Dikenal" (Install Unknown Apps) atau "Play Protect Blocked". Cukup klik **"Tetap Instal" (Install Anyway)** karena ini adalah aplikasi buatan Anda sendiri yang aman 100%.*
