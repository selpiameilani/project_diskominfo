import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Smartcitty/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sukabumi Smart City',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // Untuk animasi teks Smart City
  String smartCityText = "Smart City";
  String kotaSukabumiText = "KOTA SUKABUMI";
  int smartCityCharCount = 0;
  int kotaSukabumiCharCount = 0;
  late Timer timer;

  // Untuk scroll controller
  late ScrollController _scrollController;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // Inisialisasi scroll controller
    _scrollController = ScrollController();

    // Listener untuk mendeteksi scroll
    _scrollController.addListener(_scrollListener);

    // Memulai animasi teks setelah delay kecil
    Future.delayed(Duration(milliseconds: 300), () {
      _startSmartCityAnimation();
    });
  }

  void _scrollListener() {
    // Jika sudah dalam proses navigasi, hentikan
    if (_isNavigating) return;

    // Deteksi scroll untuk navigasi
    if (_scrollController.hasClients) {
      // Scroll ke atas yang signifikan akan memicu navigasi
      if (_scrollController.position.pixels < -80) {
        _navigateToHome();
      }
      // Scroll ke bawah yang signifikan juga akan memicu navigasi
      else if (_scrollController.position.pixels > 120) {
        _navigateToHome();
      }
    }
  }

  void _navigateToHome() {
    // Mencegah percobaan navigasi ganda
    if (_isNavigating) return;
    _isNavigating = true;

    // Berikan feedback haptic
    HapticFeedback.mediumImpact();

    // Langsung navigasi tanpa delay
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Kombinasi transisi slide up dan fade
          var begin = Offset(0.0, 0.3);
          var end = Offset.zero;
          var curve = Curves.easeOutCubic;

          var slideAnimation = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve))
              .animate(animation);

          var fadeAnimation = Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: curve))
              .animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 600),
      ),
    );
  }

  void _startSmartCityAnimation() {
    timer = Timer.periodic(Duration(milliseconds: 120), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (smartCityCharCount < smartCityText.length) {
          smartCityCharCount++;
        } else if (kotaSukabumiCharCount < kotaSukabumiText.length) {
          kotaSukabumiCharCount++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get device dimensions
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate content height to ensure it's scrollable
    final contentMinHeight = screenHeight * 1.2;

    return Scaffold(
      body: GestureDetector(
        // Membuat deteksi vertical drag lebih sensitif
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            // Swipe ke atas
            if (details.primaryVelocity! < -400) {
              _navigateToHome();
            }
            // Swipe ke bawah
            else if (details.primaryVelocity! > 400) {
              _navigateToHome();
            }
          }
        },
        child: Stack(
          children: [
            // Background putih
            Container(
              color: Colors.white,
            ),

            // Bagian gelombang biru - bergelombang di atas, lurus di bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopWaveOnlyClipper(),
                child: Container(
                  height: screenHeight * 0.35,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2196F3), // Light blue
                        Color(0xFF1976D2), // Medium blue
                        Color(0xFF1565C0), // Dark blue
                      ],
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: screenHeight * 0.13, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Teks "Supported By" di atas logo-logo
                        const Text(
                          "Supported By",
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        // Container untuk logo dengan padding horizontal
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Logo kota dengan teks
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/Lambang_Kota_Sukabumi.png',
                                    height: 32,
                                  ),
                                  const SizedBox(height: 4),
                                  const Column(
                                    children: [
                                      Text(
                                        "Pemerintah",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                      Text(
                                        "Kota Sukabumi",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Logo Diskominfo dengan teks
                              Column(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/Icon_diskom.png',
                                      height: 32,
                                      width: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Column(
                                    children: [
                                      Text(
                                        "Diskominfo",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                      Text(
                                        "Kota Sukabumi",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Logo Universitas Nusa Putra dengan teks
                              Column(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/Icon_nusputt.png',
                                      height: 32,
                                      width: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Column(
                                    children: [
                                      Text(
                                        "Universitas",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                      Text(
                                        "Nusa Putra",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Logo Itenas dengan teks
                              Column(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/Icon_Itenas.png',
                                      height: 32,
                                      width: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Itenas",
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Konten utama dengan physics yang lebih baik untuk scrolling
            SingleChildScrollView(
              // Improve scrolling behavior
              physics: const ClampingScrollPhysics(),
              controller: _scrollController,
              child: SafeArea(
                child: Container(
                  // Set minimum height to ensure content is scrollable
                  constraints: BoxConstraints(
                    minHeight: contentMinHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo tanpa frame pentagon - hanya gambar
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset(
                                    'assets/Icon_pemda.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Animasi teks Smart City
                                      Text(
                                        smartCityText.substring(
                                            0, smartCityCharCount),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          color: Color(0xFF1565C0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Animasi teks KOTA SUKABUMI
                                      Text(
                                        kotaSukabumiText.substring(
                                            0, kotaSukabumiCharCount),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF1976D2),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Memperbaiki penataan foto - menengahkan dan mendekatkan
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 45),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildProfile(
                                      imagePath: 'assets/Icon_wali.png',
                                      name: "H. Ayep Zaki, S.E., M.M.",
                                      title: "Walikota Sukabumi",
                                      isInBluePortion: false,
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Mengurangi jarak antara foto
                                    _buildProfile(
                                      imagePath: 'assets/Icon_wakil.png',
                                      name: "Bobby Maulana",
                                      title: "Wakil Walikota Sukabumi",
                                      isInBluePortion: false,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Tambahkan ruang kosong di bawah untuk memungkinkan scrolling
                            // Increased height to ensure scrollability
                            SizedBox(height: screenHeight * 0.6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile({
    required String imagePath,
    required String name,
    required String title,
    required bool isInBluePortion,
  }) {
    // Warna berdasarkan di mana profil ditampilkan
    final Color textColor =
        isInBluePortion ? Colors.white : const Color(0xFF1565C0);
    final Color subtitleColor =
        isInBluePortion ? Colors.white70 : Colors.black54;
    final Color containerColor = isInBluePortion
        ? Colors.white.withOpacity(0.2)
        : const Color(0xFF1565C0).withOpacity(0.1);

    return Column(
      children: [
        // Container foto - ukuran dikurangi untuk lebih seimbang
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 160, // Dikurangi dari 180
            width: 160, // Dikurangi dari 180
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: 70,
                height: 1,
                color: textColor.withOpacity(0.5),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Gelombang hanya di atas, lurus di bawah
class TopWaveOnlyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Mulai dari sudut kiri bawah
    path.moveTo(0, size.height);

    // Garis lurus melintasi bagian bawah
    path.lineTo(size.width, size.height);

    // Garis naik ke tepi kanan
    path.lineTo(size.width, size.height * 0.3);

    // Gelombang atas dari kanan ke kiri
    var firstTopControlPoint = Offset(size.width * 0.75, size.height * 0.05);
    var firstTopEndPoint = Offset(size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(firstTopControlPoint.dx, firstTopControlPoint.dy,
        firstTopEndPoint.dx, firstTopEndPoint.dy);

    var secondTopControlPoint = Offset(size.width * 0.25, size.height * 0.45);
    var secondTopEndPoint = Offset(0, size.height * 0.3);
    path.quadraticBezierTo(secondTopControlPoint.dx, secondTopControlPoint.dy,
        secondTopEndPoint.dx, secondTopEndPoint.dy);

    // Garis turun untuk menghubungkan kembali ke titik awal
    path.lineTo(0, size.height);

    // Tutup jalur
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
