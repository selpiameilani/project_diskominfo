import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePay extends StatelessWidget {
  const MorePay({super.key});

  void _showPaymentOptions(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pembayaran $type'),
          backgroundColor: Colors.white, // White background for popup
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PaymentOption(
                imageAsset: 'assets/Icon_tokop.jpg',
                label: 'Tokopedia',
                url: type == 'PDAM'
                    ? 'https://www.tokopedia.com/tagihan/pdam/'
                    : 'https://www.tokopedia.com/pln/',
              ),
              _PaymentOption(
                imageAsset: 'assets/Icon_blibli.webp',
                label: 'Blibli',
                url: type == 'PDAM'
                    ? 'https://www.blibli.com/digital/p/air-pdam/kota-sukabumi'
                    : 'https://www.blibli.com/digital/p/pln/prepaid',
              ),
              _PaymentOption(
                imageAsset: 'assets/Icon_cermati.png',
                label: 'Cermati',
                url: type == 'PDAM'
                    ? 'https://www.cermati.com/cek-tagihan-pdam'
                    : 'https://www.cermati.com/cek-tagihan-listrik-pln',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define denim blue color for the AppBar
    final denimBlue = const Color(0xFF1565C0); // Deep denim blue color

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: denimBlue, // Keep AppBar color as denim blue
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SimplePaymentButton(
              imageAsset: 'assets/Icon_pdam.png',
              label: 'Pembayaran PDAM',
              onTap: () => _showPaymentOptions(context, 'PDAM'),
            ),
            _SimplePaymentButton(
              imageAsset: 'assets/Icon_pln.png',
              label: 'Pembayaran PLN',
              onTap: () => _showPaymentOptions(context, 'PLN'),
            ),
          ],
        ),
      ),
    );
  }
}

// New simple payment button that matches the screenshot
class _SimplePaymentButton extends StatelessWidget {
  final String imageAsset;
  final String label;
  final VoidCallback onTap;

  const _SimplePaymentButton({
    required this.imageAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String imageAsset;
  final String label;
  final String url;

  const _PaymentOption({
    required this.imageAsset,
    required this.label,
    required this.url,
  });

  void _launchURL() async {
    final uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString(), forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _launchURL,
      leading: Image.asset(imageAsset, width: 32, height: 32),
      title: Text(label),
    );
  }
}
