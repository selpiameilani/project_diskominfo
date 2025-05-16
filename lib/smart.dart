import 'package:flutter/material.dart';
import 'package:smartcitty/smart_governance.dart';
import 'package:smartcitty/smart_economy.dart';
import 'package:smartcitty/smart_branding.dart';
import 'package:smartcitty/smart_living.dart';
import 'package:smartcitty/smart_society.dart';
import 'package:smartcitty/smart_environment.dart';

class smartPage extends StatelessWidget {
  const smartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320, // Lebar tetap untuk dialog
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris pertama: 3 ikon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickIcon(
                  icon: Icons.security,
                  label: 'Governance',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SmartGovernance()),
                    );
                  },
                ),
                _QuickIcon(
                  icon: Icons.language,
                  label: 'Branding',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SmartBranding()),
                    );
                  },
                ),
                _QuickIcon(
                  icon: Icons.monetization_on,
                  label: 'Economy',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SmartEconomy()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30), // Jarak yang lebih besar antara baris
            // Baris kedua: 3 ikon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickIcon(
                  icon: Icons.home,
                  label: 'Living',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SmartLiving()),
                    );
                  },
                ),
                _QuickIcon(
                  icon: Icons.people,
                  label: 'Society',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SmartSociety()),
                    );
                  },
                ),
                _QuickIcon(
                  icon: Icons.forest,
                  label: 'Environment',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SmartEnvironment()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Lebar tetap untuk memastikan semua ikon sejajar
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF1565C0),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(height: 8), // Jarak yang konsisten antara ikon dan label
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}