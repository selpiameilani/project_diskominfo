import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreCCTV extends StatelessWidget {
  const MoreCCTV({super.key});

  final String _url = 'http://36.66.130.9:83/doc/page/login.asp?_1678951609769';

  void _showCredentialDialog(BuildContext context) {
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
              onPressed: () => Navigator.of(context).pop(), // Close
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _launchURL(); // Buka URL
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _launchURL() async {
    final Uri uri = Uri.parse(_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Langsung tampilkan popup saat masuk halaman
    Future.delayed(Duration.zero, () => _showCredentialDialog(context));

    return Scaffold(
      appBar: AppBar(title: const Text('CCTV')),
      body: const Center(child: Text('Mengalihkan ke halaman CCTV...')),
    );
  }
}
