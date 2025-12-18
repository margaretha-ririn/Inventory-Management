import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:inventory/services/api_service.dart';
   import 'package:inventory/models/user_model.dart';
   import 'package:inventory/screens/dashboard.dart';
   // dst...

class ArduinoDetailScreen extends StatelessWidget {
  const ArduinoDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF03A9F4);

    const int currentStock = 24;
    const int maxStock = 30;
    final double ratio = (currentStock / maxStock).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                "Arduino Uno R3",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 26),
                  onPressed: () {},
                ),
              ],
              expandedHeight: 320,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFEBF7FF),
                        Color(0xFFF6F7FB),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 110, 20, 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFE9EDF3)),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: -0.08,
                          child: Image.asset(
                            'assets/arduino.png',
                            width: 300,
                            height: 240,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 280,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F6FF),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.memory,
                                  size: 88,
                                  color: Color(0xFF00979D),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + chips
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            'Arduino Uno R3',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              height: 1.1,
                            ),
                          ),
                        ),
                        _chip(
                          text: "Active",
                          bg: Color(0xFFE8F5E9),
                          fg: Color(0xFF2E7D32),
                          icon: Icons.check_circle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        _chip(
                          text: "SKU: ELEC-001",
                          bg: Color(0xFFF0F1F5),
                          fg: Color(0xFF4B5563),
                          icon: Icons.qr_code_2,
                        ),
                        SizedBox(width: 10),
                        _chip(
                          text: "High Stock",
                          bg: Color(0xFFE3F2FD),
                          fg: Color(0xFF1565C0),
                          icon: Icons.inventory_2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Stock',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '$currentStock',
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Text(
                                  '/ $maxStock units',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${(ratio * 100).round()}% Full',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 10,
                              backgroundColor: const Color(0xFFE9EDF3),
                              valueColor: const AlwaysStoppedAnimation<Color>(primary),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: const [
                        Expanded(
                          child: _infoCard(
                            icon: Icons.location_on_rounded,
                            iconColor: Color(0xFFFF5722),
                            iconBg: Color(0xFFFFE0B2),
                            label: 'LOCATION',
                            value: 'Lab 3, Cabinet B',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _infoCard(
                            icon: Icons.category_rounded,
                            iconColor: Color(0xFF1E88E5),
                            iconBg: Color(0xFFBBDEFB),
                            label: 'CATEGORY',
                            value: 'Microcontrollers',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Expanded(
                          child: _infoCard(
                            icon: Icons.verified_rounded,
                            iconColor: Color(0xFF2E7D32),
                            iconBg: Color(0xFFC8E6C9),
                            label: 'CONDITION',
                            value: 'Good',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _infoCard(
                            icon: Icons.access_time_rounded,
                            iconColor: Color(0xFF7B1FA2),
                            iconBg: Color(0xFFE1BEE7),
                            label: 'LAST UPDATED',
                            value: 'Oct 24, 2023',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The Arduino Uno R3 is a microcontroller board based on the ATmega328P. '
                      'It has 14 digital input/output pins (of which 6 can be used as PWM outputs), '
                      '6 analog inputs, a 16 MHz ceramic resonator, a USB connection, a power jack, '
                      'an ICSP header, and a reset button.',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Colors.grey[700],
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE9EDF3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.history, color: Colors.black),
                        label: const Text(
                          'History Log',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                        label: const Text(
                          'Edit Item',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EDF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData icon;

  const _chip({
    required this.text,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _infoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _infoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EDF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}