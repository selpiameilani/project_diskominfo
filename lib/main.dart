import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartcitty/home.dart';

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
  late ScrollController _scrollController;
  bool _isNavigating = false;
  bool _showScrollIndicator = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_showScrollIndicator && _scrollController.position.pixels != 0) {
      setState(() {
        _showScrollIndicator = false;
      });
    }
    if (_isNavigating) return;
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels < -80 ||
          _scrollController.position.pixels > 120) {
        _navigateToHome();
      }
    }
  }

  void _navigateToHome() {
    if (_isNavigating) return;
    _isNavigating = true;
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 0.3);
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
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final contentMinHeight = screenHeight * 1.2;

    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (_showScrollIndicator) {
              setState(() {
                _showScrollIndicator = false;
              });
            }
            if (details.primaryVelocity! < -400 ||
                details.primaryVelocity! > 400) {
              _navigateToHome();
            }
          }
        },
        child: Stack(
          children: [
            Container(color: Colors.white),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopWaveOnlyClipper(),
                child: Container(
                  height: screenHeight * 0.32, // Slightly reduced height
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF1976D2),
                        Color(0xFF1565C0),
                      ],
                    ),
                  ),
                  // Completely restructured footer to avoid overflow
                  child: SizedBox(
                    height: screenHeight * 0.35, // Match parent height
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                      children: [
                        const Spacer(),
                        const Text(
                          "Supported By",
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                        const SizedBox(height: 5),
                        // Wrap in a fixed-height container with horizontal scrolling if needed
                        SizedBox(
                          height: 70,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                // Logo Pemerintah Kota Sukabumi
                                _buildLogoItem(
                                  logo: 'assets/Lambang_Kota_Sukabumi.png',
                                  title1: "Pemerintah",
                                  title2: "Kota Sukabumi",
                                  height: 28, // Slightly smaller
                                ),
                                const SizedBox(width: 25),
                                // Logo Diskominfo
                                _buildLogoItem(
                                  logo: 'assets/Icon_diskom.png',
                                  title1: "Diskominfo",
                                  title2: "Kota Sukabumi",
                                  height: 28, // Slightly smaller
                                  isCircular: true,
                                ),
                                const SizedBox(width: 25),
                                // Logo IT Development Team
                                _buildLogoItem(
                                  logo: 'assets/ss.png',
                                  title1: "IT Develoment Team",
                                  title2: "(Intership Program)",
                                  height: 28, // Slightly smaller
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // Add safe bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (_showScrollIndicator &&
                    scrollNotification is! ScrollStartNotification) {
                  setState(() {
                    _showScrollIndicator = false;
                  });
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: _scrollController,
                child: SafeArea(
                  child: Container(
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
                                  SizedBox(
                                    width: 70,
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
                                        const Text(
                                          "Smart City",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Color(0xFF1565C0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "KOTA SUKABUMI",
                                          style: TextStyle(
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
                              const SizedBox(height: 10),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          _buildProfile(
                                            imagePath: 'assets/Icon_wali.png',
                                            name: "H. Ayep Zaki, S.E., M.M.",
                                            title: "Walikota Sukabumi",
                                            isInBluePortion: false,
                                          ),
                                          const SizedBox(width: 15),
                                          _buildProfile(
                                            imagePath: 'assets/Icon_wakil.png',
                                            name: "Bobby Maulana",
                                            title: "Wakil Walikota Sukabumi",
                                            isInBluePortion: false,
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      const SizedBox(height: 25),
                                      const Text(
                                        "Mewujudkan Sukabumi IMAN melalui Smart City",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFF1565C0),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Tambahkan ruang kosong di bawah untuk memungkinkan scrolling
                              SizedBox(height: screenHeight * 0.3),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_showScrollIndicator)
              Positioned(
                bottom: screenHeight * 0.3,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _navigateToHome,
                    child: ScrollIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Redesigned helper method for creating logo items in the footer
  Widget _buildLogoItem({
    required String logo,
    required String title1,
    required String title2,
    required double height,
    bool isCircular = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Keep column as small as possible
      children: [
        isCircular
            ? ClipOval(
                child: Image.asset(
                  logo,
                  height: height,
                  width: height,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                logo,
                height: height,
                fit: BoxFit.contain,
              ),
        const SizedBox(height: 3), // Reduced spacing
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title1,
            style: const TextStyle(fontSize: 7, color: Colors.white),
          ),
        ),
        const SizedBox(height: 1), // Reduced spacing
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title2,
            style: const TextStyle(fontSize: 7, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProfile({
    required String imagePath,
    required String name,
    required String title,
    required bool isInBluePortion,
  }) {
    final Color textColor =
        isInBluePortion ? Colors.white : const Color(0xFF1565C0);
    final Color subtitleColor =
        isInBluePortion ? Colors.white70 : Colors.black54;
    final Color containerColor = isInBluePortion
        ? Colors.white.withOpacity(0.2)
        : const Color(0xFF1565C0).withOpacity(0.1);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 140,
            width: 140,
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

class ScrollIndicator extends StatefulWidget {
  @override
  State<ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: const Offset(0, 0.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(
          Icons.keyboard_arrow_up,
          color: Color(0xFF1565C0),
          size: 24,
        ),
      ),
    );
  }
}

class TopWaveOnlyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.3);
    var firstTopControlPoint = Offset(size.width * 0.75, size.height * 0.05);
    var firstTopEndPoint = Offset(size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(firstTopControlPoint.dx, firstTopControlPoint.dy,
        firstTopEndPoint.dx, firstTopEndPoint.dy);
    var secondTopControlPoint = Offset(size.width * 0.25, size.height * 0.45);
    var secondTopEndPoint = Offset(0, size.height * 0.3);
    path.quadraticBezierTo(secondTopControlPoint.dx, secondTopControlPoint.dy,
        secondTopEndPoint.dx, secondTopEndPoint.dy);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}