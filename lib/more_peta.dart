import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MorePetaPage extends StatefulWidget {
  const MorePetaPage({super.key});

  @override
  _MorePetaPageState createState() => _MorePetaPageState();
}

class _MorePetaPageState extends State<MorePetaPage> {
  LatLng _center = LatLng(-6.934, 106.951); // Default center Sukabumi
  final TextEditingController _controller = TextEditingController();
  List<Marker> _markers = [];
  double _zoom = 14.0;
  bool _isLoadingLocation = false;
  LatLng? _userLocation;

  // Lokasi khusus di Sukabumi
  final Map<String, LatLng> _specialLocations = {
    'kantor diskominfo': LatLng(-6.9277, 106.9292),
    'diskominfo': LatLng(-6.9277, 106.9292),
    'kantor wali kota': LatLng(-6.9231, 106.9290),
    'balai kota': LatLng(-6.9231, 106.9290),
    'lapang merdeka': LatLng(-6.9244, 106.9298),
    'alun-alun': LatLng(-6.9244, 106.9298),
  };

  // Mapping kata Bahasa Indonesia ke tag OSM dalam Bahasa Inggris
  final Map<String, List<String>> _indonesianToOsmTags = {
    'sekolah': ['school', 'college', 'university', 'education'],
    'rumah sakit': ['hospital', 'clinic', 'doctors', 'healthcare'],
    'masjid': ['mosque', 'place_of_worship', 'religion=muslim'],
    'gereja': ['church', 'place_of_worship', 'religion=christian'],
    'pasar': ['marketplace', 'market', 'supermarket', 'mall'],
    'restoran': ['restaurant', 'food', 'cafe'],
    'hotel': ['hotel', 'hostel', 'guest_house', 'accommodation'],
    'kantor polisi': ['police', 'public_service'],
    'kantor pos': ['post_office'],
    'terminal': ['bus_station', 'terminal'],
    'stasiun': ['train_station', 'station'],
    'taman': ['park', 'garden'],
    'apotik': ['pharmacy', 'chemist'],
    'atm': ['atm', 'bank'],
    'bank': ['bank'],
    'spbu': ['fuel', 'gas_station'],
    'bengkel': ['car_repair', 'repair'],
    'kampus': ['university', 'college'],
    'pom bensin': ['fuel', 'gas_station'],
    'warung': ['convenience', 'shop'],
    'kantor': ['office', 'government', 'public_building'],
    'stadion': ['stadium', 'sports_centre'],
    'kolam renang': ['swimming_pool', 'sport'],
  };

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Get user location when page loads
  }

  // Function to get user's current location
  Future<void> _getUserLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission still denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak')),
          );
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // User denied permission forever
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Izin lokasi ditolak secara permanen. Silakan aktifkan di pengaturan.'),
          ),
        );
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update state with user location
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;

        // Always add user location marker regardless of location
        _addUserLocationMarker();

        // Center map on user location
        _center = _userLocation!;
        _zoom = 15.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi: $e')),
      );
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  // Add user location marker to map
  void _addUserLocationMarker() {
    if (_userLocation != null) {
      // Create a new list of markers
      List<Marker> updatedMarkers = List.from(_markers);

      // Remove any existing user location markers (to avoid duplicates)
      updatedMarkers.removeWhere((marker) {
        // Check if this is likely a user location marker based on its properties
        if (marker.point == _userLocation) {
          return true;
        }

        // Try to identify user location markers by their icon
        if (marker.child is GestureDetector) {
          final gestureDetector = marker.child as GestureDetector;
          if (gestureDetector.child is Container) {
            final container = gestureDetector.child as Container;
            if (container.child is Icon) {
              final icon = container.child as Icon;
              return icon.icon == Icons.my_location;
            }
          }
        }

        return false;
      });

      // Add user location marker - using a blue circle like in the image
      updatedMarkers.add(
        Marker(
          point: _userLocation!,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Lokasi Anda'),
                  content: Text(
                    'Koordinat: ${_userLocation!.latitude.toStringAsFixed(6)}, ${_userLocation!.longitude.toStringAsFixed(6)}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
            // child: Container(
            //   height: 24,
            //   width: 24,
            //   decoration: BoxDecoration(
            //     color: Colors.blue.withOpacity(0.4),
            //     shape: BoxShape.circle,
            //     border: Border.all(color: Colors.white, width: 2),
            //   ),
            //   child: const Icon(
            //     Icons.my_location,
            //     color: Colors.white,
            //     size: 14,
            //   ),
            // ),
          ),
        ),
      );

      setState(() {
        _markers = updatedMarkers;
      });
    }
  }

  // Center map on user's location
  void _centerOnUserLocation() {
    if (_userLocation != null) {
      setState(() {
        _center = _userLocation!;
        _zoom = 16.0;
      });
    } else {
      // Try to get user location first
      _getUserLocation().then((_) {
        if (_userLocation != null) {
          setState(() {
            _center = _userLocation!;
            _zoom = 16.0;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lokasi pengguna tidak tersedia')),
          );
        }
      });
    }
  }

  Future<void> _searchPOI(String query) async {
    // Periksa apakah query cocok dengan lokasi khusus
    String queryLower = query.toLowerCase();

    // Cari di lokasi khusus
    for (var key in _specialLocations.keys) {
      if (key.contains(queryLower) || queryLower.contains(key)) {
        final location = _specialLocations[key]!;
        String name =
            key[0].toUpperCase() + key.substring(1); // Kapitalisasi nama

        setState(() {
          _markers = [
            Marker(
              point: location,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(name),
                      content: Text(
                          'Lokasi: ${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
                child: Tooltip(
                  message: name,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
            ),
          ];
          _center = location;
          _zoom = 16.0; // Zoom in untuk lokasi khusus
        });

        // Add user location marker if available
        if (_userLocation != null) {
          _addUserLocationMarker();
        }
        return; // Keluar dari fungsi karena sudah menemukan lokasi khusus
      }
    }

    // Persiapkan bounding box yang cukup besar di sekitar Sukabumi
    // Format: south,west,north,east
    String bbox = "-7.034,106.851,-6.834,107.051";

    // Cek apakah query ada di mapping bahasa Indonesia
    List<String> osmTags = [];

    // Cari match lengkap terlebih dahulu
    if (_indonesianToOsmTags.containsKey(queryLower)) {
      osmTags = _indonesianToOsmTags[queryLower]!;
    } else {
      // Jika tidak ada match lengkap, cari kata yang mengandung query
      for (var key in _indonesianToOsmTags.keys) {
        if (key.contains(queryLower) || queryLower.contains(key)) {
          osmTags.addAll(_indonesianToOsmTags[key]!);
        }
      }
    }

    // Jika tidak ada tag yang cocok, gunakan query original
    if (osmTags.isEmpty) {
      osmTags = [query];
    }

    // Buat query Overpass API untuk mencari POI (Point of Interest)
    // Gabungkan semua tag yang relevan
    String tagConditions = osmTags.map((tag) {
      return """
        node["amenity"~"${tag}"](${bbox});
        node["name"~"${query}"](${bbox});
        node["building"~"${tag}"](${bbox});
        way["amenity"~"${tag}"](${bbox});
        way["name"~"${query}"](${bbox});
        way["building"~"${tag}"](${bbox});
        relation["amenity"~"${tag}"](${bbox});
        relation["name"~"${query}"](${bbox});
        relation["building"~"${tag}"](${bbox});
      """;
    }).join("\n");

    String overpassQuery = """
      [out:json];
      area[name="Sukabumi"];
      (
        ${tagConditions}
      );
      out center;
    """;

    final encoded = Uri.encodeComponent(overpassQuery);
    final uri =
        Uri.parse('https://overpass-api.de/api/interpreter?data=${encoded}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['elements'].isNotEmpty) {
          List<Marker> newMarkers = [];

          // Proses hasil pencarian
          for (var element in data['elements']) {
            double lat, lon;
            String name = 'Tidak ada nama';

            // Ekstrak lokasi
            if (element['type'] == 'node') {
              lat = element['lat'];
              lon = element['lon'];
            } else if (element.containsKey('center')) {
              lat = element['center']['lat'];
              lon = element['center']['lon'];
            } else {
              continue; // Lewati jika tidak ada informasi lokasi
            }

            // Ekstrak nama jika ada
            if (element['tags'] != null && element['tags']['name'] != null) {
              name = element['tags']['name'];
            }

            // Tambahkan marker dengan icon yang sesuai kategori
            IconData iconData = Icons.location_on;
            Color iconColor = Colors.red;
            
            // Set icon sesuai kategori (contoh sederhana)
            if (queryLower.contains('resto') || queryLower.contains('makan')) {
              iconData = Icons.restaurant;
              iconColor = Colors.orange;
            } else if (queryLower.contains('hotel')) {
              iconData = Icons.hotel;
              iconColor = Colors.blue;
            } else if (queryLower.contains('sekolah') || queryLower.contains('kampus')) {
              iconData = Icons.school;
              iconColor = Colors.purple;
            } else if (queryLower.contains('bank') || queryLower.contains('atm')) {
              iconData = Icons.account_balance;
              iconColor = Colors.green;
            }

            newMarkers.add(
              Marker(
                point: LatLng(lat, lon),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(name),
                        content: Text(
                            'Lokasi: ${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Tooltip(
                    message: name,
                    child: Icon(
                      iconData,
                      color: iconColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
            );
          }

          // Update markers dan center ke lokasi pertama
          setState(() {
            _markers = newMarkers;
            if (newMarkers.isNotEmpty) {
              _center = newMarkers[0].point;
              _zoom = 13.0; // Zoom out sedikit untuk melihat lebih banyak hasil
            }
          });

          // Add user location marker if available
          if (_userLocation != null) {
            _addUserLocationMarker();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada hasil ditemukan')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal mendapatkan data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map as full background
          FlutterMap(
            options: MapOptions(
              center: _center,
              zoom: _zoom,
              backgroundColor: const Color(0xFF1565C0),
              onTap: (_, position) {
                print("Koordinat: ${position.latitude}, ${position.longitude}");
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'http://{s}.google.com/vt?lyrs=s,h&x={x}&y={y}&z={z}',
                subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                userAgentPackageName: 'com.example.sukabumismartcitty',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),

          // App Bar - styled like the image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF1565C0),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Peta Sukabumi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 56 + 10,
            left: 16,
            right: 16,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Cari lokasi di Kota Sukabumi...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onSubmitted: (value) {
                        _searchPOI(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Custom location button - in a circle similar to the image
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: _isLoadingLocation
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
                    : const Icon(Icons.my_location, color: Colors.blue),
                onPressed: _isLoadingLocation ? null : _centerOnUserLocation,
              ),
            ),
          ),

          // User coordinates indicator - similar to the reference image
          if (_userLocation != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56 + 70,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.gps_fixed, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
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