
import 'package:flutter/material.dart';
import 'stat_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER BACYAYUK
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7F3),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EEE6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Color(0xFF315C49),
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Baca',
                                style: TextStyle(
                                  color: Color(0xFF315C49),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Yuk',
                                style: TextStyle(
                                  color: Color(0xFF79A98B),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Your Digital Reading Companion',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ISI DASHBOARD
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 750,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GREETING
                        const Text(
                          'Halo, Pembaca! 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF315C49),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Yuk, luangkan waktu untuk membaca hari ini.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // STATISTIK MEMBACA
                        const Text(
                          'Aktivitas Membacamu',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: const [
                            Expanded(
                              child: StatCard(
                                icon: Icons.menu_book_rounded,
                                title: 'Total Buku',
                                value: '0',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: StatCard(
                                icon: Icons.auto_stories_rounded,
                                title: 'Sedang Dibaca',
                                value: '0',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: StatCard(
                                icon: Icons.check_circle_outline,
                                title: 'Selesai Dibaca',
                                value: '0',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // LANJUTKAN MEMBACA
                        const Text(
                          'Lanjutkan Membaca',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 42,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Belum Ada Buku',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Buku yang sedang kamu baca akan muncul di sini.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // AJAKAN MEMBACA
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3EEE6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Temukan Bacaan Baru!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF315C49),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Jelajahi berbagai buku menarik dan mulai perjalanan membacamu.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.auto_stories_rounded,
                                size: 42,
                                color: Color(0xFF477A65),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
