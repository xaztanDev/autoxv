@echo off

echo ===================================================
echo   AutoXV-v1 - Sleek Interface App Builder (Windows)
echo ===================================================
echo.

:: 1. PERBAIKAN OTOMATIS UNTUK GRADLE WRAPPER JAR (Anti-Corrupt / LFS Pointer)
set "JAR_PATH=gradle\wrapper\gradle-wrapper.jar"
set "JAR_SIZE=0"

if exist "%JAR_PATH%" (
    for %%I in ("%JAR_PATH%") do set "JAR_SIZE=%%~zI"
)

:: Jika ukuran file kurang dari 5000 bytes (5KB), itu adalah LFS pointer (sekitar 130 bytes) atau corrupt
if %JAR_SIZE% LSS 5000 (
    echo [PERBAIKAN] Mendeteksi file '%JAR_PATH%' tidak valid atau rusak (Git LFS pointer).
    echo Mengunduh file 'gradle-wrapper.jar' asli yang sehat secara otomatis...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/gradle/gradle-wrapper/8.7/gradle-wrapper-8.7.jar' -OutFile 'gradle\wrapper\gradle-wrapper.jar'"
    if errorlevel 1 (
        echo [ERROR] Gagal mengunduh gradle-wrapper.jar secara otomatis.
        echo Silakan pastikan komputer Anda terhubung ke internet.
    ) else (
        echo [SUKSES] Berhasil memulihkan gradle-wrapper.jar asli yang sehat!
        echo.
    )
)

:: 2. DETEKSI OTOMATIS JAVA JDK 17+
set "JDK_FOUND=0"

:: Cek apakah JAVA_HOME bawaan valid
if exist "%JAVA_HOME%\bin\javac.exe" (
    set "JDK_FOUND=1"
    echo [INFO] Menggunakan JAVA_HOME aktif: %JAVA_HOME%
) else (
    echo [INFO] Mencari instalasi Java JDK 17+ di folder standar komputer Anda...
    :: Cari di folder instalasi standar secara bertahap untuk kompatibilitas penuh
    for /d %%d in (
        "C:\Program Files\Eclipse Adoptium\jdk-17*"
        "C:\Program Files\Java\jdk-17*"
        "C:\Program Files\Microsoft\jdk-17*"
        "C:\Program Files\Eclipse Adoptium\jdk-21*"
        "C:\Program Files\Java\jdk-21*"
    ) do (
        if exist "%%d\bin\javac.exe" (
            set "JAVA_HOME=%%d"
            set "JDK_FOUND=1"
        )
    )
)

if "%JDK_FOUND%"=="1" (
    echo [INFO] Berhasil menemukan JDK yang valid di: %JAVA_HOME%
    echo.
    echo [1/2] Membersihkan dan Membangun APK (assembleDebug)...
    call gradlew.bat assembleDebug
    
    if errorlevel 1 (
        echo.
        echo [ERROR] Gagal membangun aplikasi.
        echo Jika Anda baru saja menginstal JDK baru, silakan restart VS Code / terminal Anda terlebih dahulu.
        echo.
        pause
        exit /b 1
    ) else (
        echo.
        echo [2/2] Selesai! APK berhasil dibangun.
        echo.
        echo [PROSES] Menyalin file APK ke lokasi yang mudah dijangkau...
        
        :: 1. Salin ke Folder Root Project (Sebelah file build-apk.bat ini)
        copy /y "app\build\outputs\apk\debug\app-debug.apk" "AutoXV-App.apk" >nul
        if errorlevel 1 (
            echo [WARNING] Gagal menyalin ke folder utama project.
        ) else (
            echo [OK] Berhasil menyalin ke folder utama project:
            echo      =^> AutoXV-App.apk
        )
        
        :: 2. Salin ke Folder Downloads Pengguna di Windows
        set "DOWNLOADS_COPIED=0"
        if defined USERPROFILE (
            if exist "%USERPROFILE%\Downloads" (
                copy /y "app\build\outputs\apk\debug\app-debug.apk" "%USERPROFILE%\Downloads\AutoXV-App.apk" >nul
                if not errorlevel 1 (
                    set "DOWNLOADS_COPIED=1"
                    echo [OK] Berhasil menyalin langsung ke folder Downloads komputer Anda:
                    echo      =^> %USERPROFILE%\Downloads\AutoXV-App.apk
                )
            )
        )
        
        echo.
        echo [INFO] Membuka folder secara otomatis...
        if "%DOWNLOADS_COPIED%"=="1" (
            start "" "%USERPROFILE%\Downloads"
        ) else (
            start "" "app\build\outputs\apk\debug"
        )
        
        echo.
        echo Silakan ambil file 'AutoXV-App.apk' di folder Downloads Anda, lalu kirim ke HP Android Anda!
        echo ===================================================
        pause
    )
) else (
    echo.
    echo ===================================================
    echo [ERROR] Java JDK 17+ Tidak Ditemukan atau Tidak Valid!
    echo ===================================================
    echo Aplikasi ini membutuhkan Java JDK 17 untuk proses build.
    echo.
    echo CARA INSTALASI INSTAN (Sangat Direkomendasikan):
    echo 1. Buka CMD/PowerShell baru sebagai Administrator.
    echo 2. Jalankan perintah berikut untuk menginstal JDK 17 secara otomatis:
    echo.
    echo    winget install EclipseAdoptium.Temurin.17.JDK
    echo.
    echo 3. Setelah instalasi selesai, TUTUP dan BUKA KEMBALI VS Code / CMD Anda,
    echo    lalu jalankan kembali file 'build-apk.bat' ini.
    echo.
    echo ATAU download installer manual (.msi) dari:
    echo https://adoptium.net/temurin/releases/?version=17
    echo ===================================================
    echo.
    pause
    exit /b 1
)
