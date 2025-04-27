import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // Add this for Timer
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'detail_news.dart';
import 'detail_beranda.dart';

// Import your footer widget
import 'footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> _news = [];
  bool _isLoading = true;
  String _error = '';

  // Weather data
  bool _isLoadingWeather = true;
  String _temperature = "29°C";
  String _weatherDescription = "Tidak diketahui";
  String _feelsLike = "26°C";
  int _weatherCode = 0;

  // Image slider variables
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _imageList = [
    'assets/slide1.png',
    'assets/slide2.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchNews();
    fetchWeather();

    // Initialize PageController for image slider
    _pageController = PageController(initialPage: 0);

    // Set up timer for auto-sliding images
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imageList.length - 1) {
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

  // Format tanggal dari WordPress API
  String formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateString; // Kembalikan string asli jika format gagal
    }
  }

  // Menghapus tag HTML dari konten
  String stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Future<void> fetchNews() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://portal.sukabumikota.go.id/wp-json/wp/v2/posts?per_page=5&_embed'),
        headers: {
          'User-Agent': 'Mozilla/5.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> newsList = [];

        for (var item in data) {
          // Ekstrak gambar dengan penanganan error yang lebih baik
          String imageUrl = '';
          try {
            if (item['_embedded'] != null &&
                item['_embedded']['wp:featuredmedia'] != null &&
                item['_embedded']['wp:featuredmedia'].isNotEmpty &&
                item['_embedded']['wp:featuredmedia'][0]['source_url'] !=
                    null) {
              imageUrl = item['_embedded']['wp:featuredmedia'][0]['source_url'];
            } else if (item['_embedded'] != null &&
                item['_embedded']['wp:featuredmedia'] != null &&
                item['_embedded']['wp:featuredmedia'].isNotEmpty &&
                item['_embedded']['wp:featuredmedia'][0]['media_details'] !=
                    null &&
                item['_embedded']['wp:featuredmedia'][0]['media_details']
                        ['sizes'] !=
                    null &&
                item['_embedded']['wp:featuredmedia'][0]['media_details']
                        ['sizes']['medium'] !=
                    null) {
              imageUrl = item['_embedded']['wp:featuredmedia'][0]
                  ['media_details']['sizes']['medium']['source_url'];
            }
          } catch (e) {
            print('Error mendapatkan gambar: $e');
          }

          // Ekstrak dan bersihkan konten dengan penanganan error yang lebih baik
          String content = '';
          try {
            if (item['content'] != null &&
                item['content']['rendered'] != null) {
              content = stripHtmlTags(item['content']['rendered']);
            }
          } catch (e) {
            print('Error mendapatkan konten: $e');
            content = "Konten tidak tersedia";
          }

          // Ekstrak dan format tanggal
          String date = '';
          try {
            if (item['date'] != null) {
              date = formatDate(item['date']);
            }
          } catch (e) {
            print('Error format tanggal: $e');
            date = "Tanggal tidak tersedia";
          }

          newsList.add({
            "title": item['title']?['rendered'] ?? "Tidak ada judul",
            "date": date,
            "content": content,
            "imageUrl": imageUrl,
          });
        }

        setState(() {
          _news = newsList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Gagal memuat data berita: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan saat memuat berita: $e';
        _isLoading = false;
      });
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
            _error = 'Data cuaca tidak lengkap';
            _isLoadingWeather = false;
          });
        }
      } else {
        setState(() {
          _error = 'Gagal memuat data cuaca: ${response.statusCode}';
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching weather: $e';
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
    // Get current time to determine if it's day or night
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
          await fetchNews();
          await fetchWeather();
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Welcome Bar with proper status bar padding
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    16, // Add status bar height
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
                          "Selamat Datang di Sukabumi Smart City",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "Dapatkan informasi terkini seputar Kota Sukabumi.",
                          style: TextStyle(
                            fontSize: 12,
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
                  // Image Slider (Left side - takes 60% of width)
                  Expanded(
                    flex: 6,
                    child: Container(
                      height: 120, // Increased height to avoid cropping
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
                          itemCount: _imageList.length,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.asset(
                              _imageList[index],
                              fit: BoxFit
                                  .contain, // Changed from cover to contain
                              alignment: Alignment.center,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8), // Space between slider and weather

                  // Weather Card (Right side - takes 40% of width)
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 120, // Match the slider height
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

            // Layanan Publik dan "Lihat Semua" - Sesuai dengan gambar
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

            // Grid Layanan - Sesuai dengan gambar
            LayananGridWidget(),

            // Tambahkan ruang lebih banyak di bawah grid layanan
            const SizedBox(height: 45),

            // Berita Kota Header dengan spacing yang diperbaiki
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 6.0, top: 10.0),
              child: Text(
                'Berita Kota',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_error),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: fetchNews,
                      child: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ],
                ),
              )
            else if (_news.isEmpty)
              const Center(child: Text('Tidak ada berita'))
            else
              ..._news.map((newsItem) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailNewsScreen(
                            title: newsItem['title']!,
                            date: newsItem['date']!,
                            content: newsItem['content']!,
                            imageUrl: newsItem['imageUrl']!,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Berita dengan penanganan error yang lebih baik
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: newsItem['imageUrl']!.isNotEmpty
                                ? Image.network(
                                    newsItem['imageUrl']!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: const Color.fromRGBO(255, 252, 252, 1),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: const Color.fromRGBO(255, 253, 253, 1),
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                          size: 30,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: const Color.fromRGBO(255, 254, 254, 1),
                                    child: const Icon(
                                      Icons.article,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      size: 30,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  newsItem['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  newsItem['date']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  newsItem['content']!,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

            // Add small space before the footer
            const SizedBox(height: 20),

            // Add the Footer component here
            const Footer(),

            // Tambahkan padding di bagian bawah untuk menghindari overlapping dengan bottom navigation
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // Build page indicator dots
  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _imageList.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? const Color(0xFF1565C0)
                : const Color(
                    0xFFCCCCCC), // Changed to a light gray color for better visibility
          ),
        ),
      );
    }
    return indicators;
  }

  Widget _buildWeatherCard() {
    return Container(
      height: 120, // Match slider height
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
}

class LayananGridWidget extends StatelessWidget {
  LayananGridWidget({Key? key}) : super(key: key);

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
      'label': 'LPSE',
      'image': 'assets/Icon_LPSE.jpg',
      'url': 'http://lpse.jabarprov.go.id/'
    },
    {
      'label': 'DPMPTSP',
      'image': 'assets/Icon_dpmptsp.jpg',
      'url': 'https://dpmptsp.sukabumikota.go.id/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Mengukur lebar layar untuk mengatur ukuran grid dengan lebih presisi
    final screenWidth = MediaQuery.of(context).size.width;

    // Menghitung ukuran item berdasarkan lebar layar
    final itemWidth = (screenWidth - 32 - 15) /
        4; // 32 untuk padding horizontal, 15 untuk spacing

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
            onTap: () async {
              final url = layananList[index]['url'];
              if (url != null) {
                try {
                  final Uri uri = Uri.parse(url);
                  if (!await launchUrl(uri,
                      mode: LaunchMode.externalApplication)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tidak dapat membuka $url')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
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
