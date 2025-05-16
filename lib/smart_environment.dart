import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmartEnvironment extends StatefulWidget {
  const SmartEnvironment({super.key});

  @override
  State<SmartEnvironment> createState() => _SmartSocietyState();
}

class _SmartSocietyState extends State<SmartEnvironment> {
  // Define colors
  final Color primaryColor = const Color(0xFF2196F3); // Main blue color
  final Color lightBlue = const Color(0xFFE3F2FD); // Light blue background
  final Color instagramPink = const Color(0xFFE1306C); // Instagram pink color

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
        title: const Text("Smart Environment"),
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
                  "Tentang Smart Environment",
                  primaryColor,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Konsep yang mengacu pada pemanfaatan teknologi dan inovasi untuk menciptakan lingkungan yang berkelanjutan, efisien, dan ramah lingkungan. Tujuan dari Smart Environment adalah untuk menjaga dan meningkatkan kualitas lingkungan, mengurangi dampak negatif terhadap alam, serta mempromosikan penggunaan sumber daya secara bijaksana.',
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
        'Pengelolaan Sampah Reduce-Reuse-Recycle (TPS3R) - DLH',
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
          child: SizedBox(
            width: 110,
            height: 110,
            child: Image.asset('assets/Icon_dlh.png'),
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
                  _launchURL('http://dlh.sukabumikota.go.id/');
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
                        'dlh.sukabumikota.go.id',
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

              // Instagram button - NOW WITH LIGHT BLUE BACKGROUND
              InkWell(
                onTap: () {
                  _launchURL('https://www.instagram.com/dlh.kotasukabumi/');
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
                      FaIcon(FontAwesomeIcons.instagram,
                          color: instagramPink, size: 15),
                      SizedBox(width: 10),
                      Text(
                        'dlh.kotasukabumi',
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
                  'Pengelolaan sampah berbasis 3R (Reduce, Reuse dan Recycle) merupakan pendekatan sistem yang dijadikan sebagai solusi pemecahan masalah persampahan dengan meningkatkan kepedulian dan peran serta masyarakat dalam pelaksanaan kebersihan lingkungan dan pengelolaan sampah mandiri.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}
