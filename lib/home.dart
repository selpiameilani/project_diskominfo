import 'package:flutter/material.dart';
import 'package:Smartcitty/beranda.dart';
import 'package:Smartcitty/category.dart'; // Quick dialog
import 'package:Smartcitty/more.dart'; // More dialog

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  // Removed the unused _selectedDialogIndex field

  final List<Widget> _pages = [
    HomeScreen(), // 0: Home
    Placeholder(), // 1: Quick (tidak ditampilkan)
    Placeholder(), // 2: More (tidak ditampilkan)
  ];

  void _onTabTapped(int index) {
    if (index == 1) {
      showDialog(
        context: context,
        builder: (_) => const CategoryPage(),
      );
    } else if (index == 2) {
      showDialog(
        context: context,
        builder: (_) => const MorePage(),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // Selalu mengembalikan warna biru
  Color _iconColor(int index) {
    return const Color(0xFF1565C0); // Selalu biru untuk semua ikon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _onTabTapped(1),
          backgroundColor: const Color(0xFF1565C0),
          elevation: 8,
          child: const Icon(Icons.touch_app, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 55),
            painter: BottomNavBarPainter(),
          ),
          SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: _iconColor(0),
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: _iconColor(0),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Spacer for FAB
                Expanded(child: Container()),

                // More
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: _iconColor(2),
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'More',
                          style: TextStyle(
                            color: _iconColor(2),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Label Quick di bawah FAB
          Positioned(
            bottom: 5,
            child: Text(
              'Quick',
              style: TextStyle(
                color: _iconColor(1), // Warna biru
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk membuat bottom navigation bar melengkung
class BottomNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.42, 0);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.58,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}