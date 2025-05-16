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
    },
    {
      'name': 'RSUD Al-Mulk',
      'address':
          'Jl. Pelabuhan II, Lembursitu, Kec. Lembursitu,\nKota Sukabumi, Jawa Barat 43169',
      'phone': '(0266)6220941',
    },
  ];

  final List<Map<String, dynamic>> healthCenters = [
    {
      'name': 'PUSKESMAS SELABATU',
      'address': 'Jl. Kenari No. 3 Kelurahan Selabatu Kec. Cikole',
      'phone': '(0266) 229944',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
        'Klinik Sore : Pukul 15.00 s.d. 19.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS SUKABUMI',
      'address': 'Jl. R.A. Kosasih No. 147 Ciaul, Kota Sukabumi',
      'phone': '(0266) 6253204',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
        'Klinik Sore : Pukul 15.00 s.d. 19.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS CIPELANG',
      'address': 'Jl.KH.Ahmad Sanusi No.21 Sukabumi',
      'phone': '(0266) 225041',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS KARANGTENGAH',
      'address':
          'Jalan Tanjung Sari No.14 Kel. Karang Tengah Kec. Gunung Puyuh Kota Sukabumi',
      'phone': '(0266) 239168',
      'hours': [
        'Senin-Kamis/ 07.00-15.00 WIB',
        'Jum\'at/ 07.00-14.00 WIB',
        'Sabtu/07.00-10.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS PABUARAN',
      'address': 'Jln. Pabuaran No. 49 Kel. Nyomplong Kec Warudoyong Sukabumi',
      'phone': '0266-231890',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS BENTENG',
      'address':
          'Jl. Benteng Kidul No.70, Kel. Benteng, Kec. Warudoyong, Kota Sukabumi',
      'phone': '0266-225219',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS SUKAKARYA',
      'address': 'Jl. Sukakarya Sukabumi',
      'phone': '0266-217931',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS GEDONG PANJANG',
      'address': 'Jl. R.H. Didi Sukardi No. 229 Kota Sukabumi',
      'phone': '(0266) 211414',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS TIPAR',
      'address': 'Jl. Pelabuhan 2 Tipar, Citamiang Kota Sukabumi',
      'phone': '(0266) 222985',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS NANGGELENG',
      'address':
          'JL. Pelda Suyatna, 43151, Nanggeleng, kec. citamiang kota sukabumi',
      'phone': '(0266) 217894',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS BAROS',
      'address': 'Jl. Baros, Baros, Kota Sukabumi, Jawa Barat 43161',
      'phone': '(0266) 211040',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
        'Klinik Sore : Pukul 15.00 s.d. 19.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS LEMBURSITU',
      'address':
          'Jl.Pelabuan II Km.6 Kelurahan Lembursitu Kecamatan Lembursitu Kota Sukabumi',
      'phone': '(0266) 231295-2',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS CIKUNDUL',
      'address': 'Jl. Merdeka No. 291, Kec. Lembur Situ Sukabumi',
      'phone': '0266-240041',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS LIMUSNUNGGAL',
      'address': 'Jl. Rawa Belut No.05, Kec. Cibeureum Sukabumi',
      'phone': ' (0266) 215558',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
    },
    {
      'name': 'PUSKESMAS CIBEUREUM HILIR',
      'address': 'Jl. Ciandam , Kec. Cibeureum Kota Sukabumi',
      'phone': ' (0266) 242116',
      'hours': [
        'Senin s.d. Kamis Dan Sabtu : Pukul 07.30 s.d. Pukul 14.45 WIB',
        'Istirahat : Pukul 12.00 s.d. Pukul 13.00 WIB',
        'Jumat : Pukul 07.30 s.d. Pukul 15.15 WIB',
        'Istirahat : Pukul 11.30 s.d. Pukul 13.00 WIB',
      ],
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

                _buildInnovationHeader("Inovasi"),

                const SizedBox(height: 11),

                // PSC 119 Sigap Homecare info - Fixed layout to prevent overflow
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PSC 119 Sigap Homecare",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "layanan ambulance kegawatdaruratan medis/emergency bagi masyarakat Kota Sukabumi yang membutuhkan AMBULANCE",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "AMBULAN SIGAP Kota Sukabumi,",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),
                        // Menyatukan semua informasi kontak dalam satu baris
                        Row(
                          children: [
                            const Text(
                              "Call Center: ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () async {
                                final Uri uri =
                                    Uri(scheme: 'tel', path: '08001000119');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              child: const Text(
                                "0800 1000 119",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "atau: ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () async {
                                final Uri uri = Uri(scheme: 'tel', path: '119');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              child: const Text(
                                "119",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
                ),

                const SizedBox(height: 14),

                // Hospitals Section
                _buildInnovationHeader("Klinik sore "),

                const SizedBox(height: 11),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: hospitals.length,
                  itemBuilder: (context, index) {
                    return _buildHospitalCard(hospitals[index]);
                  },
                ),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: healthCenters.length,
                  itemBuilder: (context, index) {
                    return _buildHealthCenterCard(healthCenters[index]);
                  },
                ),

                const SizedBox(height: 20),

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
                                    color: const Color(0xFFE3F2FD),
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
                          color: const Color(0xFFE3F2FD),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF1A5CBE), // Warna biru denim
            ),
          ),
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
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
          children: [
            Container(
              color: cardContentBg,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address
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
                    // Phone number with call functionality
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
                            hospital['phone'] ?? '',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCenterCard(Map<String, dynamic> healthCenter) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF1A5CBE), // Warna biru denim
            ),
          ),
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Text(
              healthCenter['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Container(
              color: cardContentBg,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address
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
                            healthCenter['address'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Phone
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
                            final phoneNumber = healthCenter['phone']
                                    ?.replaceAll(RegExp(r'[^0-9+]'), '') ??
                                '+6281234567890';
                            final Uri uri =
                                Uri(scheme: 'tel', path: phoneNumber);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          child: Text(
                            healthCenter['phone'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Operating Hours
                    const Text(
                      'Jam Operasional: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // List operating hours
                    ...List.generate(
                      (healthCenter['hours'] as List).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(fontSize: 11),
                            ),
                            Expanded(
                              child: Text(
                                healthCenter['hours'][index],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the first line of an address (up to the newline character)
  String _getFirstLine(String address) {
    final parts = address.split('\n');
    return parts.isNotEmpty ? parts[0] : address;
  }

  // Helper method to check if address has a second line
  bool _hasSecondLine(String address) {
    final parts = address.split('\n');
    return parts.length > 1;
  }

  // Helper method to get the second line of an address
  String _getSecondLine(String address) {
    final parts = address.split('\n');
    return parts.length > 1 ? parts[1] : '';
  }
}
