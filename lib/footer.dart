import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      // Add bottom padding to account for navigation bar
      margin: const EdgeInsets.only(bottom: 60.0),
      // Using Colors.white to match the app background
      color: const Color.fromARGB(255, 248, 247, 247),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'mau tau lebih banyak? yuk ikuti sosial media kami',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialMediaIcon(
                icon: FontAwesomeIcons.instagram,
                color: const Color(0xFFE4405F),
                onTap: () => _launchURL(
                    'https://www.instagram.com/diskominfo_sukabumikota?igsh=OGl6eGM5dG1pYndx'),
              ),
              _socialMediaIcon(
                icon: FontAwesomeIcons.youtube,
                color: const Color(0xFFFF0000),
                onTap: () => _launchURL(
                    'https://youtube.com/@pemerintahkotasukabumi?si=_uAIYsY-cYH7g3z6'),
              ),
              _socialMediaIcon(
                icon: FontAwesomeIcons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () =>
                    _launchURL('https://www.facebook.com/share/15f3i7o2GP/'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialMediaIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Changed border color to match the white background
        border: Border.all(color: const Color.fromARGB(255, 235, 234, 234).withOpacity(0.1)),
        // Using Colors.white for the social media icon backgrounds
        color: Colors.white,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }

  Future _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
