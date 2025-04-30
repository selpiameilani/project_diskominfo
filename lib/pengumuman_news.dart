import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Halaman Detail Pengumuman yang Disempurnakan
class AnnouncementPage extends StatelessWidget {
  final Map<String, dynamic> pengumuman;
  
  const AnnouncementPage({Key? key, required this.pengumuman}) : super(key: key);

  // Fungsi untuk membuka URL
  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://portal.sukabumikota.go.id/category/pengumuman/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format tanggal
    String formattedDate = "";
    try {
      final date = DateTime.parse(pengumuman['date']);
      final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
      formattedDate = formatter.format(date);
    } catch (e) {
      formattedDate = "Tanggal tidak valid";
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
        backgroundColor: const Color(0xFF1565C0),
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
            
            // Isi pengumuman dengan link "Selanjutnya" tanpa jarak
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
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = _launchURL,
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