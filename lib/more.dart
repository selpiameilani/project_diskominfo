import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'more_pay.dart'; // Pastikan ini mengimpor kelas yang benar
import 'more_peta.dart'; // Pastikan ini mengimpor kelas yang benar

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  // Fungsi untuk meluncurkan URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  // Fungsi untuk menampilkan dialog CCTV
  void _showCCTVDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informasi Login CCTV'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: Polres'),
              Text('Password: Restasmi'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Tutup dialog
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _launchURL('http://36.66.130.9:83/doc/page/login.asp?_1678951609769');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickIcon(
                icon: Icons.videocam,
                label: 'CCTV',
                onTap: () => _showCCTVDialog(context),
              ),
              _QuickIcon(
                icon: Icons.payment,
                label: 'Pembayaran',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MorePay()), // Pastikan nama kelas benar
                  );
                },
              ),
              _QuickIcon(
                icon: Icons.map,
                label: 'Peta',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LokasiPage()), // Pastikan nama kelas benar
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _QuickIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF1565C0),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}