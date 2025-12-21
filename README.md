# *Invantry - Inventory Management*

# Struktur Kelompok (Tim)
- Ririn Margaretha Simanjuntak (241712011)
- Visela Benedicta Simarmata (241712031)
- Muhammad Ramadhan (241712034)
- Olo Briliant Simarmata (241712038)
- Peter Rangga Situmorang (241712039)

# Deskripsi Singkat Aplikasi
Inventory Management App adalah aplikasi mobile berbasis Android yang dikembangkan menggunakan flutter untuk membantu pengguna dalam mengelola data persediaan barang secara digital. Aplikasi ini mendukung pencatatan stok, pemantauan ketersediaan barang, laporan inventaris serta pengelolaan transaksi masuk dan keluar secara efisien.

# Daftar Fitur pada Aplikasi
*Login & Autentikasi Pengguna

*Dashboard ringkasan stok barang

*Tambah, ubah, dan hapus data barang

*Management stok masuk dan stok keluar

*Peringatan stok menipis (low stock alert)

*Riwayat transaksi barang

*Laporan Inventaris

*Halaman Profil Pengguna

*Navigasi menggunakan Bottom Navigation Bar

*Mode Gelap (Dark Mode), Terang 

# Stack Technology yang digunakan
*Flutter Version: 3.35.3

*Dart Version: 3.9.0

*Flutter SDK Tools: 2.48.0

*Android SDK : 36.1.0

*Library/Framework yang digunakan:

    Flutter SDK: Framework UI Utama
    
    Dart: Bahasa Pemrograman utama dalam Pengembangan aplikasi Flutter
    
    Flutter SDK Tools: Digunakan untuk build aplikasi, debugging, hot reload, dan manajemen dependensi
    
    Android SDK: Digunakan sebagai platform target untuk deployment aplikasi Android
  
*Public/Private API yang digunakan:

  Private API: 
  
               1. Autentikasi Pengguna (Login & Register)

               2. Manajemen Data Barang
               
               3. Transaksi stok masuk dan kelusr
               
               4. Penyimpanan dan Pengambilan laporan inventaris
               
  Private API ini hanya dapat diakses oleh aplikasi dan tidak tersedia untuk pengguna publik

# Cara Menjalankan Aplikasi
1. Persyaratan Sistem
   
    Flutter SDK terinstal (versi sesuai yang digunakan di proyek).
  
    Dart SDK (biasanya sudah termasuk di Flutter).
  
    Android Studio atau VS Code dengan ekstensi Flutter.

    Emulator atau perangkat fisik Android untuk pengujian.
  
    Git (opsional, jika clone dari repository).
  
3. Menjalankan Aplikasi Flutter
   
    Panduan berikut menjelaskan langkah-langkah menjalankan aplikasi CampusFind.

    Clone repository
  
    Salin project dari GitHub ke komputer:
   
      git clone https://github.com/margaretha-ririn/Inventory-Management.git
    
    Masuk ke folder project Pindah ke direktori project:
   
      cd Inventory-Management
    
    Install dependencies Install semua package yang diperlukan aplikasi:
   
      flutter pub get
      
    Cek device atau emulator Pastikan tersedia device untuk menjalankan aplikasi:
   
      flutter devices
   
    Bisa menggunakan emulator Android/iOS atau perangkat fisik yang terhubung.
  
    Jalankan aplikasi Jalankan aplikasi pada device yang tersedia:
   
      flutter run
      
    Mode release (opsional) Untuk versi final yang lebih cepat dan siap digunakan:
   
      flutter run --release
    
    Troubleshooting Jika terjadi error dependency:
   
      flutter clean
   
      flutter pub get
    
Jika Flutter tidak dikenali, pastikan Flutter sudah terinstall dan PATH telah dikonfigurasi. Jika device tidak muncul, periksa emulator atau pastikan perangkat fisik berada dalam mode developer.
