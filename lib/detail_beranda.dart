import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBeranda extends StatefulWidget {
  const DetailBeranda({super.key});

  static const List<Map<String, dynamic>> allServices = [
    {
      'label': 'BPJS',
      'image': 'assets/Icon_BPJS.png',
      'url': 'https://www.bpjs-kesehatan.go.id/',
      'smart': 'Pusat'
    },
    {
      'label': 'Lapor',
      'image': 'assets/Icon_Lapor.png',
      'url': 'https://www.lapor.go.id/',
      'smart': 'Pusat'
    },
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
      'label': 'Mal Pelayanan Publik',
      'image': 'assets/Icon_mpp.png',
      'url': 'https://mpp.sukabumikota.go.id/layanan',
    },
    {
      'label': 'Open Data',
      'image': 'assets/Icon_open.png',
      'url': 'https://opendata.sukabumikota.go.id/',
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
      'label': 'Sapawarga',
      'image': 'assets/Icon_sapawarga.png',
      'url': 'https://jabarprov.go.id/sapawarga',
    },
    {
      'label': 'OSS',
      'image': 'assets/Icon_oss.png',
      'url': 'https://oss.go.id/',
    },
    {
      'label': 'KAI',
      'image': 'assets/Icon_KAI.jpg',
      'url': 'https://www.kai.id//',
    },
    {
      'label': 'Satu Sehat',
      'image': 'assets/Icon_satusehat.jpg',
      'url': 'https://satusehat.kemkes.go.id/sdmk',
    },
    {
      'label': 'JDIH Nasional',
      'image': 'assets/Icon_jdihnasio.png',
      'url': 'https://jdihn.go.id/',
    },
    {
      'label': 'Satu Data Nasional',
      'image': 'assets/icon_satunasio.png',
      'url': '  https://data.go.id/',
    },
    {
      'label': 'Dekranasda Kota Sukabumi',
      'image': 'assets/Icon_dekena.png',
      'url': 'https://sikanda.sukabumikota.go.id/',
    },
    {
      'label': 'JDIH Provinsi',
      'image': 'assets/Icon_jidhprov.png',
      'url': 'https://jdih.jabarprov.go.id/',
    },
  ];

  @override
  State<DetailBeranda> createState() => _DetailBerandaState();
}

class _DetailBerandaState extends State<DetailBeranda> {
  late List<Map<String, dynamic>> filteredServices;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredServices = DetailBeranda.allServices;
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
        filteredServices = DetailBeranda.allServices;
      } else {
        filteredServices = DetailBeranda.allServices
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
      appBar: AppBar(title: const Text("Semua Layanan")),
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
                    crossAxisCount: 3,
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
