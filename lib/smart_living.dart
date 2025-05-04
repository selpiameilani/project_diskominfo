import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmartLiving extends StatefulWidget {
  const SmartLiving({super.key});

  @override
  State<SmartLiving> createState() => _SmartLivingState();
}

class _SmartLivingState extends State<SmartLiving> {
  final List<Map<String, String>> hospitals = [
    {
      'name': 'RSUD Syamsuddin, S.H. (Bunut)',
      'address':
          'Jl. Rumah Sakit No.1, Cikole, Kec. Cikole,\nKota Sukabumi, Jawa Barat 43113',
      'phone': '(0266)225180',
      'image': 'assets/Icon_RSUD.png',
    },
    {
      'name': 'RSUD Al-Mulk',
      'address':
          'Jl. Pelabuhan II, Lembursitu, Kec. Lembursitu,\nKota Sukabumi, Jawa Barat 43169',
      'phone': '(0266)6220941',
      'image': 'assets/Icon_Almulk.webp',
    },
  ];

  // Define the primary color to match the image - brighter blue
  final Color primaryColor = const Color(0xFF0277BD);

  // Page background color (white)
  final Color backgroundColor = Colors.white;

  // Button colors
  final Color darkBlue = const Color(0xFF0277BD); // Denim blue for headers
  final Color lightBlue =
      const Color(0xFFB3E5FC); // Light blue for clinic button
  final Color cardContentBg =
      const Color(0xFFE1F5FE); // Even lighter blue for card content
  // Define the missing playstoreGreen color
  final Color playstoreGreen = const Color(0xFF00C853);

  // Define the missing _launchURL method
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Living"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tentang Smart Living Section
                _buildSectionCard(
                  "Tentang Smart Living",
                  primaryColor,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Sebuah konsep yang menggabungkan teknologi dan inovasi untuk meningkatkan kualitas hidup dan kenyamanan bagi individu dan masyarakat. Konsep ini melibatkan penggunaan teknologi informasi, komunikasi, dan internet yang terintegrasi dalam berbagai aspek kehidupan sehari-hari, seperti rumah, transportasi, kesehatan, energi, keamanan, dan lingkungan.',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Inovasi Section
                _buildInnovationHeader("Inovasi"),

                const SizedBox(height: 11),

                // Clinic Services Section - Separate buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  const Color(0xFFE3F2FD),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "klinik Sore dan PSC 119 Sigap Homecare",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Hospitals Section
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: hospitals.length,
                  itemBuilder: (context, index) {
                    return _buildHospitalCard(hospitals[index]);
                  },
                ),

                const SizedBox(height: 20),

                // JKN Mobile Section - UPDATED TO MATCH DESIGN
                // No card container - directly in the column to match page background
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // JKN Mobile Title - Using consistent lightBlue (0xFFB3E5FC)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "JKN Mobile - BPJS Kesehatan",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // JKN Logo and Button Side by Side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // JKN Logo - slightly larger (120x120)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/Icon_jkn.webp',
                              width: 110,
                              height: 110,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Only PlayStore button - made smaller
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: InkWell(
                                onTap: () {
                                  _launchURL(
                                      'https://play.google.com/store/apps/details?id=app.bpjs.mobile&hl=id');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color:  const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.googlePlay,
                                          color: playstoreGreen, size: 15),
                                      SizedBox(width: 10),
                                      Text(
                                        'JKN Mobile',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // JKN Description - Using consistent lightBlue (0xFFB3E5FC)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:  const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ', style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    'aplikasi JKN Mobile berperan penting dalam meningkatkan kualitas hidup masyarakat melalui kemudahan akses layanan kesehatan. Aplikasi ini memungkinkan pengguna untuk mengakses informasi kepesertaan, fasilitas kesehatan, dan administrasi JKN secara digital tanpa harus datang langsung ke kantor BPJS atau rumah sakit.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ', style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    'Dengan integrasi layanan kesehatan ke dalam platform digital, JKN Mobile mendukung kehidupan masyarakat yang lebih sehat, efisien, dan nyaman—ciri khas kota pintar yang menempatkan kesejahteraan warganya sebagai prioritas utama.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Color color, Widget content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: cardContentBg,
            width: double.infinity,
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildInnovationHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 2,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, String> hospital) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              hospital['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: cardContentBg,
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: hospital['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              hospital['image']!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.local_hospital,
                            color: Colors.blue,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address in format similar to screenshot
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alamat : ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _getFirstLine(hospital['address'] ?? ''),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Second line of address with padding to align properly
                        if (_hasSecondLine(hospital['address'] ?? ''))
                          Padding(
                            padding: const EdgeInsets.only(left: 46.0),
                            child: Text(
                              _getSecondLine(hospital['address'] ?? ''),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        // Phone number in format similar to screenshot
                        Row(
                          children: [
                            const Text(
                              'Telepon : ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final phoneNumber = hospital['phone']
                                        ?.replaceAll(RegExp(r'[^0-9+]'), '') ??
                                    '+6281234567890';
                                final Uri uri =
                                    Uri(scheme: 'tel', path: phoneNumber);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              child: Text(
                                hospital['phone'] ?? '(0266)6220941',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  // Helper methods to split address into two lines
  String _getFirstLine(String address) {
    if (address.contains('\n')) {
      return address.split('\n')[0];
    }
    return address;
  }

  String _getSecondLine(String address) {
    if (address.contains('\n')) {
      return address.split('\n')[1];
    }
    return '';
  }

  bool _hasSecondLine(String address) {
    return address.contains('\n');
  }
}
