import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import 'detail_beranda.dart';
import 'footer.dart';
import 'beranda_kec.dart';
import 'beranda_badan.dart';
import 'beranda_dinas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Weather data
  bool _isLoadingWeather = true;
  String _temperature = "29°C";
  String _weatherDescription = "Tidak diketahui";
  String _feelsLike = "26°C";
  int _weatherCode = 0;

  // Image slider variables
  late PageController _pageController;
  int _currentPage = 0;
  final List<Map<String, dynamic>> _sliderItems = [
    {
      'image': 'assets/slide1.png',
      'url': 'https://disdukcapil.sukabumikota.go.id/',
      'title': 'Disdukcapil Kota Sukabumi',
    },
    {
      'image': 'assets/slide2.png',
      'url': 'https://dinkes.sukabumikota.go.id/',
      'title': 'Dinkes Kota Sukabumi',
    },
    {
      'image': 'assets/slide3.jpg',
      'url': 'https://dinkes.sukabumikota.go.id/beranda',
      'title': 'Dinkes Kota Sukabumi',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather();

    // Initialize PageController for image slider
    _pageController = PageController(initialPage: 0);

    // Set up timer for auto-sliding images
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _sliderItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Replace WebView with direct URL launcher
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> fetchWeather() async {
    setState(() {
      _isLoadingWeather = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=-6.875&longitude=106.875&current=temperature_2m,apparent_temperature,weather_code&timezone=auto'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['current'] != null) {
          setState(() {
            _temperature = "${data['current']['temperature_2m']}°C";
            _feelsLike = "${data['current']['apparent_temperature']}°C";
            _weatherCode = data['current']['weather_code'];
            _weatherDescription = getWeatherDescription(_weatherCode);
            _isLoadingWeather = false;
          });
        } else {
          setState(() {
            _isLoadingWeather = false;
          });
        }
      } else {
        setState(() {
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return "Cerah";
      case 1:
      case 2:
      case 3:
        return "Berawan";
      case 45:
      case 48:
        return "Berkabut";
      case 51:
      case 53:
      case 55:
        return "Gerimis";
      case 56:
      case 57:
        return "Gerimis Dingin";
      case 61:
      case 63:
      case 65:
        return "Hujan";
      case 66:
      case 67:
        return "Hujan Dingin";
      case 71:
      case 73:
      case 75:
        return "Salju";
      case 80:
      case 81:
      case 82:
        return "Hujan Lebat";
      case 85:
      case 86:
        return "Hujan Salju";
      case 95:
      case 96:
      case 99:
        return "Badai Petir";
      default:
        return "Tidak diketahui";
    }
  }

  IconData _getWeatherIcon(String weatherDescription) {
    final now = DateTime.now();
    final hour = now.hour;
    final isDay = hour >= 6 && hour < 18;

    switch (weatherDescription.toLowerCase()) {
      case "cerah":
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;
      case "berawan":
        return isDay ? Icons.cloud : Icons.nights_stay;
      case "berkabut":
        return Icons.cloud_queue;
      case "gerimis":
      case "gerimis dingin":
        return Icons.grain;
      case "hujan":
      case "hujan dingin":
        return Icons.water_drop;
      case "hujan lebat":
        return Icons.thunderstorm;
      case "badai petir":
        return Icons.flash_on;
      case "salju":
      case "hujan salju":
        return Icons.ac_unit;
      default:
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;
    }
  }

  Color _getWeatherIconColor(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
      case "cerah":
        return Colors.orange;
      case "berawan":
        return Colors.grey;
      case "berkabut":
        return Colors.blueGrey;
      case "gerimis":
      case "gerimis dingin":
        return Colors.lightBlue;
      case "hujan":
      case "hujan dingin":
        return Colors.blue;
      case "hujan lebat":
        return Colors.indigo;
      case "badai petir":
        return Colors.purple;
      case "salju":
      case "hujan salju":
        return Colors.lightBlue.shade100;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchWeather();
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Welcome Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              color: const Color(0xFF1565C0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/Lambang_Kota_Sukabumi.png',
                    width: 55,
                    height: 55,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat Datang di Portal Smart City Kota Sukabumi",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "Dapatkan informasi terkini seputar Kota Sukabumi.",
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Image Slider and Weather Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Slider
                  Expanded(
                    flex: 6,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _sliderItems.length,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () =>
                                  _launchURL(_sliderItems[index]['url']),
                              child: Image.asset(
                                _sliderItems[index]['image'],
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Weather Card
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 120,
                      child: _buildWeatherCard(),
                    ),
                  ),
                ],
              ),
            ),

            // Indicator dots for image slider
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),

            const SizedBox(height: 10),

            // Layanan Publik dan "Lihat Semua"
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Layanan Publik',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailBeranda(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // Grid Layanan
            LayananGridWidget(launchURL: _launchURL),

            const SizedBox(height: 20),

            // OPD Section
            _buildOPDSection(),

            const SizedBox(height: 20),

            // Footer
            const Footer(),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // Build page indicator dots
  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _sliderItems.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? const Color(0xFF1565C0)
                : const Color(0xFFCCCCCC),
          ),
        ),
      );
    }
    return indicators;
  }

  Widget _buildWeatherCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _isLoadingWeather
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              children: [
                // Judul "Cuaca" di pojok kiri atas
                const Positioned(
                  top: 0,
                  left: 0,
                  child: Text(
                    'Cuaca',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // "Saat Ini" di bawah judul "Cuaca"
                const Positioned(
                  top: 18,
                  left: 0,
                  child: Text(
                    'Saat Ini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),

                // Suhu di tengah bagian kiri
                Positioned(
                  top: 32,
                  left: 0,
                  child: Text(
                    _temperature,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // "Terasa seperti" di bawah suhu
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Row(
                    children: [
                      const Text(
                        'Terasa seperti ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        _feelsLike,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),

                // Icon cuaca di pojok kanan atas
                Positioned(
                  top: 5,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: _getWeatherIconColor(_weatherDescription),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getWeatherIcon(_weatherDescription),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _weatherDescription,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Build OPD Section - MODIFIED TO NAVIGATE TO LOCAL PAGES
  Widget _buildOPDSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // OPD Title
          const Text(
            'Organisasi Perangkat Daerah (OPD)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // OPD Buttons Row
          Row(
            children: [
              // BADAN Button - Navigate to BerandaBadanPage
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BerandaBadan(),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4), // Blue color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'BADAN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // KECAMATAN Button - Navigate to BerandaKecPage
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BerandaKecPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6D00), // Orange color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'KECAMATAN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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

          const SizedBox(height: 8),

          // DINAS Button - Navigate to BerandaDinasPage
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BerandaDinas(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF00C853),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'DINAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LayananGridWidget extends StatelessWidget {
  final Function(String) launchURL;

  const LayananGridWidget({Key? key, required this.launchURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mengukur lebar layar untuk mengatur ukuran grid dengan lebih presisi
    final screenWidth = MediaQuery.of(context).size.width;

    // Menghitung ukuran item berdasarkan lebar layar
    final itemWidth = (screenWidth - 32 - 15) /
        4; // 32 untuk padding horizontal, 15 untuk spacing

    // Daftar layanan dengan URL dan label
    final List<Map<String, dynamic>> layananList = [
      {
        'label': 'Portal Sukabumi',
        'image': 'assets/Lambang_Kota_Sukabumi.png',
        'url':
            'https://portal.sukabumikota.go.id/category/berita-kota/pendidikan/'
      },
      {
        'label': 'Sapawarga',
        'image': 'assets/Icon_sapawarga.png',
        'url': 'https://jabarprov.go.id/sapawarga',
      },
      {
        'label': 'Lapor',
        'image': 'assets/Icon_Lapor.png',
        'url': 'https://www.lapor.go.id/'
      },
      {
        'label': 'Moci legit',
        'image': 'assets/Icon_mochi.png',
        'url': 'https://mocilegit.sukabumikota.go.id/',
      },
      {
        'label': 'PPID',
        'image': 'assets/Icon_PPID.png',
        'url': 'https://ppid.sukabumikota.go.id/',
      },
      {
        'label': 'Satu Sehat',
        'image': 'assets/Icon_satusehat.jpg',
        'url': 'https://satusehat.kemkes.go.id/sdmk',
      },
      {
        'label': 'JKN Mobile',
        'image': 'assets/Icon_jkn.webp',
        'url':
            'https://play.google.com/store/apps/details?id=app.bpjs.mobile&hl=id'
      },
      {
        'label': 'OSS',
        'image': 'assets/Icon_oss.png',
        'url': 'https://oss.go.id/',
      },
    ];

    return Container(
      // Tinggi container ditingkatkan untuk memastikan ada ruang cukup untuk baris kedua
      height: 165,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: itemWidth / 65, // Menyesuaikan rasio aspek
          crossAxisSpacing: 5, // Jarak horizontal yang lebih kecil
          mainAxisSpacing:
              10, // Jarak vertikal lebih untuk memberi ruang vertikal lebih
        ),
        physics: const NeverScrollableScrollPhysics(), // Mencegah scroll
        itemCount: layananList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Launch URL directly in external browser
              launchURL(layananList[index]['url']!);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, // Ukuran ikon sesuai gambar
                  height: 40, // Ukuran ikon sesuai gambar
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(255, 255, 255, 1)
                            .withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      layananList[index]['image']!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 6), // Lebih banyak ruang antara ikon dan teks
                Flexible(
                  child: Text(
                    layananList[index]['label']!,
                    style: const TextStyle(
                        fontSize: 9), // Font lebih kecil sesuai gambar
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
