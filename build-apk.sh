#!/bin/bash
echo "==================================================="
echo "  AutoXV-v1 - Sleek Interface App Builder (macOS/Linux)"
echo "==================================================="
echo ""
echo "[1/2] Mengatur izin akses eksekusi gradlew..."
chmod +x gradlew

echo "[2/2] Membangun APK (assembleDebug)..."
./gradlew assembleDebug

if [ $? -ne 0 ]; then
    echo ""
    echo "[ERROR] Gagal membangun aplikasi."
    echo "Pastikan Anda sudah menginstal Java JDK 17 atau versi yang lebih baru (seperti Eclipse Temurin JDK 17)."
    echo ""
    exit 1
fi

echo ""
echo "Selesai! APK berhasil dibangun di folder berikut:"
echo "app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "Silakan kirim file 'app-debug.apk' ke HP Android Anda (lewat WhatsApp Web, Telegram, Google Drive, Email, atau Bluetooth) untuk diinstal langsung secara gratis tanpa kabel USB!"
echo "==================================================="
