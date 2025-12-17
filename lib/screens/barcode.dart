import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen>
    with SingleTickerProviderStateMixin {
  // Controller untuk kamera
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  // Controller untuk animasi laser merah
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    // Setup animasi laser (naik turun)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran area scan (kotak tengah)
    final double scanWindowSize = MediaQuery.of(context).size.width * 0.75;

    // Warna sesuai desain
    const Color kPrimaryBlue = Color(0xFF0095FF);

    return Scaffold(
      backgroundColor: Colors
          .black, // Background dasar hitam agar saat loading tidak putih silau
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Pindai Barcode',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // LAYER 1: KAMERA
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                // LOGIKA KETIKA BARCODE TERDETEKSI
                debugPrint('Barcode found! ${barcode.rawValue}');
                // Matikan kamera sebentar biar gak spam detect
                controller.stop();

                // Tampilkan hasil (Contoh Alert Dialog)
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Berhasil Pindai"),
                    content: Text("Kode: ${barcode.rawValue}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          controller.start(); // Nyalakan kamera lagi
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          // LAYER 2: OVERLAY GELAP DENGAN LUBANG
          CustomPaint(
            painter: ScannerOverlayPainter(scanWindowSize: scanWindowSize),
            child: Container(),
          ),

          // LAYER 3: ELEMEN UI DI ATAS KAMERA
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label "KAMERA AKTIF"
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'KAMERA AKTIF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // AREA SCANNER (FRAME BIRU + LASER)
                SizedBox(
                  width: scanWindowSize,
                  height: scanWindowSize, // Kotak persegi
                  child: Stack(
                    children: [
                      // Sudut-sudut Biru (Blue Corners)
                      CustomPaint(
                        size: Size(scanWindowSize, scanWindowSize),
                        painter: ScannerCornersPainter(color: kPrimaryBlue),
                      ),

                      // Garis Merah (Laser) Animasi
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned(
                            top:
                                _animation.value *
                                (scanWindowSize -
                                    10), // -10 agar tidak keluar border
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.8),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Label Instruksi Bawah
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Arahkan kamera ke barcode barang',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                // Spacer agar tidak tertutup panel bawah
                const SizedBox(height: 100),
              ],
            ),
          ),

          // LAYER 4: BOTTOM SHEET (PANEL KONTROL)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar kecil di tengah atas sheet
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Tombol Flash & Riwayat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCircleButton(
                        icon: _isFlashOn ? Icons.flash_off : Icons.flash_on,
                        label: 'Flash',
                        onTap: () {
                          setState(() {
                            _isFlashOn = !_isFlashOn;
                            controller.toggleTorch();
                          });
                        },
                      ),
                      const SizedBox(width: 40),
                      _buildCircleButton(
                        icon: Icons.history,
                        label: 'Riwayat',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider "ATAU"
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'ATAU',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tombol Input Manual
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.keyboard, color: Colors.white),
                      label: const Text(
                        'Input Kode Manual',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Tombol Bulat
  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Icon(icon, color: Colors.grey[700]),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// --- CUSTOM PAINTERS UNTUK UI YANG PRESISI ---

// Painter 1: Membuat overlay gelap dengan lubang di tengah
class ScannerOverlayPainter extends CustomPainter {
  final double scanWindowSize;
  ScannerOverlayPainter({required this.scanWindowSize});

  @override
  void paint(Canvas canvas, Size size) {
    final double scanWindowOffset = (size.width - scanWindowSize) / 2;
    // Posisi lubang agak ke atas sedikit biar balance (center vertikal area kosong)
    final double scanWindowTop = (size.height - scanWindowSize) / 2 - 50;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Rect cutout = Rect.fromLTWH(
      scanWindowOffset,
      scanWindowTop,
      scanWindowSize,
      scanWindowSize,
    );

    // Path background penuh
    final Path backgroundPath = Path()..addRect(rect);
    // Path lubang tengah (rounded rect)
    final Path cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(20)));

    // Gabungkan path (background - lubang)
    final Path finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final Paint paint = Paint()
      ..color = Colors.black
          .withOpacity(0.6) // Tingkat kegelapan overlay
      ..style = PaintingStyle.fill;

    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Painter 2: Membuat Sudut-sudut Biru (Blue Corners)
class ScannerCornersPainter extends CustomPainter {
  final Color color;
  ScannerCornersPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = 20; // Radius lengkungan
    final double length = 40; // Panjang garis siku
    final double stroke = 4; // Ketebalan garis

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Sudut Kiri Atas
    Path pathTL = Path();
    pathTL.moveTo(0, length);
    pathTL.lineTo(0, r);
    pathTL.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    pathTL.lineTo(length, 0);
    canvas.drawPath(pathTL, paint);

    // Sudut Kanan Atas
    Path pathTR = Path();
    pathTR.moveTo(w - length, 0);
    pathTR.lineTo(w - r, 0);
    pathTR.arcToPoint(Offset(w, 0), radius: Radius.circular(r));
    pathTR.lineTo(w, length);
    canvas.drawPath(pathTR, paint);

    // Sudut Kanan Bawah
    Path pathBR = Path();
    pathBR.moveTo(w, h - length);
    pathBR.lineTo(w, h - r);
    pathBR.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    pathBR.lineTo(w - length, h);
    canvas.drawPath(pathBR, paint);

    // Sudut Kiri Bawah
    Path pathBL = Path();
    pathBL.moveTo(length, h);
    pathBL.lineTo(r, h);
    pathBL.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    pathBL.lineTo(0, h - length);
    canvas.drawPath(pathBL, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
