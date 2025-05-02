import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmartSociety extends StatefulWidget {
  const SmartSociety({super.key});

  @override
  State<SmartSociety> createState() => _SmartSocietyState();
}

class _SmartSocietyState extends State<SmartSociety> {
  // Define colors
  final Color primaryColor = const Color(0xFF2196F3); // Main blue color
  final Color lightBlue = const Color(0xFFE3F2FD); // Light blue background
  final Color youtubeRed = const Color(0xFFFF0000); // YouTube red color

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
        title: const Text("Smart Society"),
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
                  "Tentang Smart Society",
                  primaryColor,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Sebuah konsep yang menggabungkan masyarakat dengan teknologi informasi. Masyarakat berperan aktif dalam mengakses informasi, dan dukungan yang membantu mereka. Konsep ini bertujuan untuk meningkatkan kesejahteraan sosial dan menciptakan lingkungan yang inklusif, aman, dan berkelanjutan, dan memudahkan budaya hidup sesuai dengan perkembangan.',
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
        'Sistem Informasi Elektronik Data Bencana(SiEdan) - BPBD',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
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
            width: 110,
            height: 110,
            // color: Colors.black,
            child: Image.asset(
              'assets/Icon_bpbd.png',
              fit: BoxFit.cover,
            ),
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

              // Website button - NOW WITH LIGHT BLUE BACKGROUND
              InkWell(
                onTap: () {
                  _launchURL('https://siedan.sukabumikota.go.id');
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
                        'siedan.sukabumikota.go.id',
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

              // YouTube button - NOW WITH LIGHT BLUE BACKGROUND
              InkWell(
                onTap: () {
                  _launchURL('https://www.youtube.com/@bpbdkotasukabumi1516');
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
                      Icon(Icons.play_circle_fill, color: youtubeRed, size: 15),
                      SizedBox(width: 10),
                      Text(
                        'BPBD KOTA SUKABUMI',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
                  'Sistem Elekronik Online Data Bencana Kota Sukabumi Berbasis Website.',
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
                  'Merupakan data dinamis yang bermanfaat bagi masyarakat untuk membantu mengetahui titik-titik/daerah rawan bencana sebagai bahan preventif dan preemptif terhadap bencana',
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
