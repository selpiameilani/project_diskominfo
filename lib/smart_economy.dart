import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmartEconomy extends StatefulWidget {
  const SmartEconomy({super.key});

  @override
  State<SmartEconomy> createState() => _SmartSocietyState();
}

class _SmartSocietyState extends State<SmartEconomy> {
  // Define colors
  final Color primaryColor = const Color(0xFF2196F3);
  final Color lightBlue = const Color(0xFFE3F2FD);
  final Color instagramPink = const Color(0xFFE1306C);

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
        title: const Text("Smart Economy"),
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
                  "Tentang Smart Economy",
                  primaryColor,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Konsep ekonomi yang didukung oleh penggunaan teknologi informasi dan komunikasi (TIK) serta inovasi untuk mencapai pertumbuhan ekonomi yang berkelanjutan, produktivitas yang tinggi, dan inklusi sosial. Konsep ini berfokus pada pemanfaatan teknologi digital, data, dan konektivitas untuk mengoptimalkan sektor ekonomi dalam berbagai aspek, termasuk produksi, distribusi, konsumsi, dan pertukaran informasi.',
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
        'Pelatihan Vokasi Wirausaha Baru - DISKUMINDAG ',
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
            width: 110,
            height: 110,
            child: Image.asset('assets/Icon_SK.png'),
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
                  _launchURL('https://www.instagram.com/sukabumikece.id/');
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
                        'sukabumikece.id',
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
                  'Merupakan salah satu program prioritas dari program kerja Sukabumi Kece (Kelurahan Entrepreneur Center) yang bertujuan untuk menciptakan calon wirausaha baru.',
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
                  'Manfaat Program ini adalah memberikan kesempatan bagi seluruh warga masyarakat Kota Sukabumi yang memiliki minat berwirausaha untuk mengembangkan ide menjadi usaha kreatif dan inovatif.',
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
        'Culinery Night Festival - DISKUMINDAG ',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      ),
    );
  }

  // Culinary Logo and buttons row - DIPERBARUI
  Widget _buildCulinaryLogoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Culinary Logo - Menggunakan Expanded agar menyesuaikan lebar halaman
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 110,
              child: Image.asset(
                'assets/Icon_culinery.webp',
                fit: BoxFit
                    .cover, // Memastikan gambar menutupi container dengan baik
                width:
                    double.infinity, // Menggunakan lebar maksimum yang tersedia
              ),
            ),
          ),
        ),
        // Kolom tombol - Bagian ini tetap dipertahankan untuk kompatibilitas
        const SizedBox(width: 10),
        // Buttons column - Dibiarkan kosong
        Container(
          width: 0,
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
                  'Culinary Night Festival merupakan media promosi kuliner yang dikombinasikan dengan pentas musik yang dilaksanakan pada malam hari selama 3 hari.',
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
                  'Bertujuan untuk membantu pemasaran para pelaku UMKM, mendorong terciptanya wisata kuliner dan mensosialisasikan transaksi keuangan digital.',
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
