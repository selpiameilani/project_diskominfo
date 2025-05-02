import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmartGovernance extends StatefulWidget {
  const SmartGovernance({super.key});

  @override
  State<SmartGovernance> createState() => _SmartSocietyState();
}

class _SmartSocietyState extends State<SmartGovernance> {
  // Define colors
  final Color primaryColor = const Color(0xFF2196F3);
  final Color lightBlue = const Color(0xFFE3F2FD);
  final Color instagramPink = const Color(0xFFE1306C);
  final Color playstoreGreen =
      const Color(0xFF00C853); // Google Play Store color

  // Function to launch URLs
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Governance"),
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
                // Tentang Smart Society Section
                _buildSectionCard(
                  "Tentang Smart Governance",
                  primaryColor,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Suatu konsep dan pendekatan dalam pengelolaan pemerintahan yang mengintegrasikan teknologi informasi dan komunikasi (TIK) untuk meningkatkan efisiensi, transparansi, partisipasi publik, dan pelayanan yang lebih baik kepada masyarakat. Smart Governance bertujuan untuk mengoptimalkan penggunaan teknologi dalam pengambilan keputusan, pengelolaan data, dan interaksi antara pemerintah dan masyarakat.',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Inovasi Header with Line - Matches exactly as in image
                _buildInovasiHeaderWithLine(),

                const SizedBox(height: 10),

                // SiEdan title button - Light blue
                _buildSiedanTitleButton(),

                const SizedBox(height: 10),

                // Logo and Buttons Row
                _buildLogoAndButtonsRow(),

                const SizedBox(height: 10),

                // Content with bullets
                _buildBulletedContent(),

                const SizedBox(height: 10),

                // Culinary Night Festival title button
                _buildCulinaryTitleButton(),

                const SizedBox(height: 10),

                // Culinary Logo and Buttons Row
                _buildCulinaryLogoRow(),

                const SizedBox(height: 10),

                // Culinary Content with bullets
                _buildCulinaryBulletedContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Color color, Widget content) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: lightBlue,
            width: double.infinity,
            child: content,
          ),
        ],
      ),
    );
  }

  // Inovasi header with line as shown in the image
  Widget _buildInovasiHeaderWithLine() {
    return Row(
      children: [
        // Inovasi button with rounded corners
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Inovasi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Add space between button and line
        SizedBox(width: 10),

        // Horizontal line
        Expanded(
          child: Container(
            height: 2,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  // SiEdan title button in light blue
  Widget _buildSiedanTitleButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'layanan Mochi legit - DISDUKCAPIL ',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      ),
    );
  }

  // Logo and buttons row
  Widget _buildLogoAndButtonsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // BPBD Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 100,
            height: 100,
            child: Image.asset('assets/Icon_mochi.png'),
          ),
        ),
        const SizedBox(width: 10),
        // Buttons column
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height:
                      10), // Added space to align buttons with the middle of logo

              InkWell(
                onTap: () {
                  _launchURL('https://disdukcapil.sukabumikota.go.id/');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.language, color: primaryColor, size: 15),
                      SizedBox(width: 10),
                      Text(
                        'disdukcapil.sukabumikota.go.id',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Content with bullets
  Widget _buildBulletedContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
              Expanded(
                child: Text(
                  'Layanan Administrasi Kependudukan Masyarakat Kota Sukabumi — Cepat, Terintegrasi, Lebih Mudah, Gratis dan Terpercaya (Layanan Moci Legit).',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // Bullet 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              Expanded(
                child: Text(
                  'Memberikan Layanan Kependudukan (e-KTP, KIA, KK, Pindah-Datang, Akta Kelahiran dan Akta Kematian) secara online.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Culinary Night Festival title button in light blue
  Widget _buildCulinaryTitleButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Simponi -Pemerintah Kota Sukabumi',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      ),
    );
  }

  // Culinary Logo and buttons row
  Widget _buildCulinaryLogoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Culinary Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 110,
            height: 110,
            child: Image.asset('assets/Icon_simpony.webp'),
          ),
        ),
        const SizedBox(width: 10),
        // Buttons column
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  _launchURL('https://simponi.sukabumikota.go.id/');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.language, color: primaryColor, size: 15),
                      SizedBox(width: 10),
                      Text(
                        'simponi.sukabumi.go.id',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  _launchURL(
                      'https://play.google.com/store/apps/details?id=com.arlabsgroup.siap&hl=en-US');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.googlePlay,
                          color: playstoreGreen, size: 15),
                      SizedBox(width: 10),
                      Text(
                        'Simponi Kota Sukabumi',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Culinary Content with bullets
  Widget _buildCulinaryBulletedContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
              Expanded(
                child: Text(
                  'Simponi (Sistem Informasi Manajemen Pemerintahan Online) merupakan inovasi Kota Sukabumi dalam mewujudkan Smart City dengan mengintegrasikan berbagai aplikasi layanan publik ke dalam satu platform. Sistem ini meningkatkan efisiensi kerja ASN, mempercepat pelayanan kepada masyarakat, serta mendukung sistem satu data dan transparansi pemerintahan secara digital.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
