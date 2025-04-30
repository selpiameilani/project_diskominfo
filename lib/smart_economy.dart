import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Smarteconomy extends StatefulWidget {
  const Smarteconomy({super.key});

  static const List<Map<String, dynamic>> allServices = [
    {
      'label': 'Sapawarga',
      'image': 'assets/Icon_sapawarga.png',
      'url': 'https://jabarprov.go.id/sapawarga',
    },
    {
      'label': 'JDIH Provinsi',
      'image': 'assets/Icon_jidhprov.png',
      'url': 'https://jdih.jabarprov.go.id/',
    },
  ];

  @override
  State<Smarteconomy> createState() => _SmarteconomyState();
}

class _SmarteconomyState extends State<Smarteconomy> {
  late List<Map<String, dynamic>> filteredServices;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredServices = Smarteconomy.allServices;
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
        filteredServices = Smarteconomy.allServices;
      } else {
        filteredServices = Smarteconomy.allServices
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
      appBar: AppBar(title: const Text("Layanan Provinsi")),
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