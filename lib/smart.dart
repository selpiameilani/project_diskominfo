import 'package:flutter/material.dart';
import 'package:smartcitty/smart_governance.dart';
import 'package:smartcitty/smart_economy.dart';
import 'package:smartcitty/smart_branding.dart';
import 'package:smartcitty/smart_living.dart';
import 'package:smartcitty/smart_society.dart';
import 'package:smartcitty/smart_environment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class smartPage extends StatelessWidget {
  const smartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300, // Lebar tetap untuk memastikan keselarasan
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris pertama: 3 ikon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _QuickIcon(
                      icon: FontAwesomeIcons.buildingColumns,
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
                      icon: FontAwesomeIcons.bullhorn,
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
                      icon: FontAwesomeIcons.chartLine,
                      label: 'Economy',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const Smarteconomy()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Baris kedua: 3 ikon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _QuickIcon(
                      icon: FontAwesomeIcons.house,
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
                      icon: FontAwesomeIcons.userGroup,
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
                      icon: FontAwesomeIcons.leaf,
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
          const SizedBox(height: 10),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
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
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF1565C0),
            child: FaIcon(icon, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(height: 6),
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
    );
  }
}
