import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

// Halaman Detail Pengumuman yang Disempurnakan
class AnnouncementPage extends StatelessWidget {
  final Map<String, dynamic> pengumuman;

  const AnnouncementPage({Key? key, required this.pengumuman})
      : super(key: key);

  // Fungsi untuk membuka URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan tanggal yang diterima dari pengumuman
    String formattedDate = pengumuman['date'] ?? "Tanggal tidak tersedia";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengumuman',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  pengumuman['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul
            Text(
              pengumuman['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Tanggal
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Link "Selanjutnya" - Warna diubah menjadi hijau
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Jika Anda ingin melihat lebih banyak pengumuman ',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Selanjutnya',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green, // Diubah dari blue menjadi green
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(pengumuman['url'] ??
                          'https://portal.sukabumikota.go.id/category/pengumuman/'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
