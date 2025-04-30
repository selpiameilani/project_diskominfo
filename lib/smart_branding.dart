import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartBranding extends StatefulWidget {
  const SmartBranding({super.key});

  static const List<Map<String, dynamic>> allServices = [
    {
      'label': 'LPSE',
      'image': 'assets/Icon_LPSE.jpg',
      'url': 'http://lpse.jabarprov.go.id/',
    },
    {
      'label': 'RSUD Syamsudin',
      'image': 'assets/Icon_RSUD.png',
      'url': 'https://online.rsudsyamsudin.co.id/',
    },
    {
      'label': 'Moci legit',
      'image': 'assets/Icon_mochi.png',
      'url': 'https://mocilegit.sukabumikota.go.id/',
    },
    {
      'label': 'Portal Sukabumi',
      'image': 'assets/Lambang_Kota_Sukabumi.png',
      'url': 'https://portal.sukabumikota.go.id/smart/berita-kota/pendidikan/',
    },
    {
      'label': 'DPMPTSP',
      'image': 'assets/Icon_dpmptsp.jpg',
      'url': 'https://dpmptsp.sukabumikota.go.id/',
    },
    {
      'label': 'Satu Data',
      'image': 'assets/Icon_satudata.png',
      'url': 'https://satudata.sukabumikota.go.id/',
    },
    {
      'label': 'PPID',
      'image': 'assets/Icon_PPID.png',
      'url': 'https://ppid.sukabumikota.go.id/',
    },
    {
      'label': 'Simpan SPBE',
      'image': 'assets/Icon_spbe.png',
      'url': 'https://simpan-spbe.sukabumikota.go.id/',
    },
    {
      'label': 'JDIH Kota Sukabumi',
      'image': 'assets/Icon_jdih.png',
      'url': 'https://jdih.sukabumikota.go.id/',
    },
    {
      'label': 'Dekranasda Kota Sukabumi',
      'image': 'assets/Icon_dekena.png',
      'url': 'https://sikanda.sukabumikota.go.id/',
    },
  ];

  @override
  State<SmartBranding> createState() => _smartBrandingState();
}

class _smartBrandingState extends State<SmartBranding> {
  late List<Map<String, dynamic>> filteredServices;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredServices = SmartBranding.allServices;
    searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredServices = SmartBranding.allServices;
      } else {
        filteredServices = SmartBranding.allServices
            .where((service) =>
                service['label'].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Tidak dapat membuka URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Layanan Kota")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari layanan...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            if (filteredServices.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Tidak ada layanan ditemukan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (filteredServices.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final item = filteredServices[index];
                    final url = item['url'];
                    return InkWell(
                      onTap: url != null ? () => _launchURL(url) : null,
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['label']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
