import 'package:flutter/material.dart';
import 'package:Smartcitty/category_pusat.dart';
import 'package:Smartcitty/category_prov.dart';
import 'package:Smartcitty/category_kota.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickIcon(
                icon: Icons.account_balance,
                label: 'Nasional',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const CategoryPusatScreen()),
                  );
                },
              ),
              _QuickIcon(
                icon: Icons.apartment,
                label: 'Provinsi',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const CategoryProvScreen()),
                  );
                },
              ),
              _QuickIcon(
                icon: Icons.location_city,
                label: 'Kota',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const CategoryKotaScreen()),
                  );
                },
              ),
            ],
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
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
