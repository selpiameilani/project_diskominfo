import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BerandaKecPage extends StatelessWidget {
  const BerandaKecPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6D00),
        elevation: 8,
        shadowColor: Colors.orange.withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'KECAMATAN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF6D00),
                const Color(0xFFFF6D00),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kecamatan Gunungpuyuh
              _buildKecamatanCard(
                context,
                'Kecamatan Gunungpuyuh',
                'assets/Icon_gnpyh.png',
                'Jl. Bhineka Karya No.21, Karamat, Kec. Gunungpuyuh, Kota Sukabumi, Jawa Barat 43122',
                '(0266) 211950',
                'kecamatangunungpuyuh.sukabumikota.go.id',
              ),
              const SizedBox(height: 20),

              // Kecamatan Citamiang
              _buildKecamatanCard(
                context,
                'Kecamatan Citamiang',
                'assets/Icon_ctaming.JPG',
                'Jl. Raya Citamiang No.15, Citamiang, Kec. Citamiang, Kota Sukabumi, Jawa Barat 43121',
                '(0266) 225678',
                'kecamatancitamiang.sukabumikota.go.id',
              ),
              const SizedBox(height: 20),

              // Kecamatan Baros
              _buildKecamatanCard(
                context,
                'Kecamatan Baros',
                'assets/Icon_Baros.webp',
                'Jl. Tangkil - Agrabinta, Baros, Kec. Baros, Kota Sukabumi, Jawa Barat 43161',
                '(0266) 215921',
                'kecamatanbaros.sukabumikota.go.id',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKecamatanCard(
    BuildContext context,
    String title,
    String imagePath,
    String address,
    String phone,
    String website,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6D00),
            const Color(0xFFFF6D00),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header dengan judul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFF6D00),
                  const Color(0xFFFF6D00),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Content area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16), // Reduced from 20 to 16
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFFE0B2), // Orange muda light
                  const Color(0xFFFFE0B2), // Orange muda light
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  width: 70, // Reduced from 80 to 70
                  height: 70, // Reduced from 80 to 70
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey.shade100,
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFFFF6D00),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const FaIcon(
                          FontAwesomeIcons.building,
                          color: Color(0xFFFF6D00),
                          size: 35, // Reduced from 40 to 35
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12), // Reduced from 16 to 12

                // Information area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address
                      InkWell(
                        onTap: () => _openMaps(address),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), // Reduced padding
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.locationDot,
                                color: Colors.red,
                                size: 14, // Reduced from 16 to 14
                              ),
                              const SizedBox(width: 8), // Reduced from 12 to 8
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    color: Color(0xFF424242),
                                    fontSize: 11, // Reduced from 12 to 11
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced from 8 to 4

                      // Phone
                      InkWell(
                        onTap: () => _makePhoneCall(phone),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), // Reduced padding
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.phone,
                                color: Color(0xFF4FC3F7),
                                size: 14, // Reduced from 16 to 14
                              ),
                              const SizedBox(width: 8), // Reduced from 12 to 8
                              Text(
                                phone,
                                style: const TextStyle(
                                  color: Color(0xFF424242),
                                  fontSize: 12, // Reduced from 13 to 12
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced from 8 to 4

                      // Website
                      InkWell(
                        onTap: () => _openWebsite(website),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), // Reduced padding
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.globe,
                                color: Color(0xFF66BB6A),
                                size: 14, // Reduced from 16 to 14
                              ),
                              const SizedBox(width: 8), // Reduced from 12 to 8
                              Expanded(
                                child: Text(
                                  website,
                                  style: const TextStyle(
                                    color: Color(0xFF424242),
                                    fontSize: 11, // Reduced from 12 to 11
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            ),
          ),
        ],
      ),
    );
  }

  // Function to open maps
  void _openMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress';

    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    } else {
      print('Could not open maps');
    }
  }

  // Function to make phone call
  void _makePhoneCall(String phoneNumber) async {
    final phoneUrl = 'tel:$phoneNumber';

    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      print('Could not make phone call');
    }
  }

  // Function to open website
  void _openWebsite(String website) async {
    final websiteUrl = 'https://$website';

    if (await canLaunchUrl(Uri.parse(websiteUrl))) {
      await launchUrl(Uri.parse(websiteUrl));
    } else {
      print('Could not open website');
    }
  }
}