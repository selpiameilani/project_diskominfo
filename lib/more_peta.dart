import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  _LokasiPageState createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  String searchQuery = '';
  Map<String, dynamic>? searchResult;
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool isSearching = false;
  bool isLoading = false;
  LatLng? currentUserLocation;
  List<Map<String, dynamic>> searchResults = [];
  List<Marker> _poiMarkers = [];

  // Batas koordinat Kota Sukabumi yang lebih akurat
  final LatLng sukabumiBounds1 =
      LatLng(-6.9600, 106.8900); // Batas selatan-barat
  final LatLng sukabumiBounds2 = LatLng(-6.8900, 106.9600); // Batas utara-timur
  final LatLng defaultCenter =
      LatLng(-6.9175, 106.9300); // Alun-alun Kota Sukabumi

  // Data lokasi penting di Kota Sukabumi
  final List<Map<String, dynamic>> sukabumi_locations = [
    {
      'name': 'Alun-alun Kota Sukabumi',
      'lat': -6.9175,
      'lng': 106.9300,
      'smart': 'publik',
      'description': 'Alun-alun utama Kota Sukabumi, Jl. R.E. Martadinata'
    },
    {
      'name': 'Balai Kota Sukabumi',
      'lat': -6.9173,
      'lng': 106.9316,
      'smart': 'pemerintahan',
      'description': 'Kantor Walikota Sukabumi, Jl. R.E. Martadinata'
    },
    {
      'name': 'RSUD R. Syamsudin, SH',
      'lat': -6.9128,
      'lng': 106.9275,
      'smart': 'kesehatan',
      'description':
          'Rumah Sakit Umum Daerah Kota Sukabumi, Jl. Rumah Sakit No.1'
    },
    {
      'name': 'Masjid Agung Sukabumi',
      'lat': -6.9166,
      'lng': 106.9298,
      'smart': 'ibadah',
      'description': 'Masjid Agung Kota Sukabumi, Jl. R.E. Martadinata'
    },
    {
      'name': 'Stasiun Sukabumi',
      'lat': -6.9209,
      'lng': 106.9287,
      'smart': 'transportasi',
      'description': 'Stasiun Kereta Api Sukabumi, Jl. Stasiun Timur'
    },
    {
      'name': 'Terminal Sudirman',
      'lat': -6.9195,
      'lng': 106.9135,
      'smart': 'transportasi',
      'description': 'Terminal Bus Kota Sukabumi, Jl. Jenderal Sudirman'
    },
    {
      'name': 'SPBU Benteng',
      'lat': -6.9182,
      'lng': 106.9210,
      'smart': 'layanan',
      'description': 'SPBU Pertamina, Jl. Bhayangkara'
    },
    {
      'name': 'SMAN 1 Sukabumi',
      'lat': -6.9165,
      'lng': 106.9336,
      'smart': 'pendidikan',
      'description': 'SMA Negeri 1 Sukabumi, Jl. R.E. Martadinata'
    },
    {
      'name': 'SMAN 3 Sukabumi',
      'lat': -6.9082,
      'lng': 106.9261,
      'smart': 'pendidikan',
      'description': 'SMA Negeri 3 Sukabumi, Jl. Ciaul Pasir'
    },
    {
      'name': 'SMK Negeri 1 Sukabumi',
      'lat': -6.9114,
      'lng': 106.9254,
      'smart': 'pendidikan',
      'description': 'SMK Negeri 1 Sukabumi, Jl. Kabandungan'
    },
    {
      'name': 'Bank BJB Sukabumi',
      'lat': -6.9162,
      'lng': 106.9272,
      'smart': 'keuangan',
      'description': 'Bank BJB Cabang Sukabumi, Jl. Ahmad Yani'
    },
    {
      'name': 'Gedung Juang 45',
      'lat': -6.9172,
      'lng': 106.9264,
      'smart': 'pemerintahan',
      'description': 'Gedung bersejarah Kota Sukabumi, Jl. Ahmad Yani'
    },
    {
      'name': 'Pasar Pelita',
      'lat': -6.9193,
      'lng': 106.9227,
      'smart': 'belanja',
      'description': 'Pasar tradisional Kota Sukabumi, Jl. Pelita'
    },
    {
      'name': 'Sukabumi Square',
      'lat': -6.9234,
      'lng': 106.9191,
      'smart': 'belanja',
      'description':
          'Pusat perbelanjaan di Kota Sukabumi, Jl. Jenderal Sudirman'
    },
    {
      'name': 'Universitas Muhammadiyah Sukabumi',
      'lat': -6.9282,
      'lng': 106.9378,
      'smart': 'pendidikan',
      'description': 'Kampus UMMI, Jl. R. Syamsudin SH'
    },
    {
      'name': 'Taman Srigunting',
      'lat': -6.9154,
      'lng': 106.9284,
      'smart': 'publik',
      'description': 'Taman Kota Sukabumi, Jl. Ahmad Yani'
    },
    {
      'name': 'Masjid Agung Al-Istiqomah',
      'lat': -6.9152,
      'lng': 106.9173,
      'smart': 'ibadah',
      'description': 'Masjid besar di Kota Sukabumi, Jl. Ahmad Yani'
    },
    {
      'name': 'Rumah Sakit Hermina Sukabumi',
      'lat': -6.9201,
      'lng': 106.9336,
      'smart': 'kesehatan',
      'description': 'RS Hermina Sukabumi, Jl. Jenderal Sudirman'
    },
    {
      'name': 'Kantor Pos Sukabumi',
      'lat': -6.9172,
      'lng': 106.9258,
      'smart': 'layanan',
      'description': 'Kantor Pos Kota Sukabumi, Jl. Ahmad Yani'
    },
    {
      'name': 'Polres Sukabumi Kota',
      'lat': -6.9128,
      'lng': 106.9239,
      'smart': 'pemerintahan',
      'description': 'Kantor Polres Sukabumi Kota, Jl. Bhayangkara'
    }
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadDefaultLocations();
  }

  // Memuat lokasi-lokasi default di Sukabumi
  void _loadDefaultLocations() {
    setState(() {
      searchResults = sukabumi_locations;
      _updateMarkersFromResults(sukabumi_locations);
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Periksa izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Izin ditolak, gunakan lokasi default
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Izin ditolak secara permanen
        _setDefaultLocation();
        return;
      }

      // Dapatkan posisi terkini
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Periksa apakah pengguna berada di area Sukabumi
      LatLng userLocation = LatLng(position.latitude, position.longitude);
      bool isInSukabumi = _isLocationInSukabumi(userLocation);

      setState(() {
        currentUserLocation = isInSukabumi ? userLocation : null;
        isLoading = false;
      });

      // Jika lokasi pengguna berada di Sukabumi, pindahkan peta ke lokasi tersebut
      if (isInSukabumi) {
        mapController.move(userLocation, 15.0);
      } else {
        _setDefaultLocation();
      }
    } catch (e) {
      _setDefaultLocation();
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isLocationInSukabumi(LatLng location) {
    // Periksa apakah lokasi berada dalam batas Sukabumi
    return location.latitude >= sukabumiBounds1.latitude &&
        location.latitude <= sukabumiBounds2.latitude &&
        location.longitude >= sukabumiBounds1.longitude &&
        location.longitude <= sukabumiBounds2.longitude;
  }

  void _setDefaultLocation() {
    // Tetapkan lokasi default ke Alun-alun Sukabumi
    setState(() {
      currentUserLocation = null;
      isLoading = false;
    });

    // Pindahkan peta ke pusat kota Sukabumi
    mapController.move(defaultCenter, 15.0);
  }

  // Pencarian lokasi dari database lokal
  void searchLocations(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = sukabumi_locations;
        searchResult = null;
        _updateMarkersFromResults(sukabumi_locations);
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Filter lokasi berdasarkan query
      final List<Map<String, dynamic>> filteredLocations = sukabumi_locations
          .where((location) =>
              location['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              location['description']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              location['smart']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      setState(() {
        searchResults = filteredLocations;
        isLoading = false;

        if (filteredLocations.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada lokasi ditemukan')),
          );
        } else {
          // Buat markers dari hasil pencarian
          _updateMarkersFromResults(filteredLocations);

          // Jika ada hasil, pilih yang pertama sebagai default
          if (filteredLocations.isNotEmpty) {
            searchResult = filteredLocations.first;

            // Pindahkan peta ke lokasi hasil pencarian pertama
            WidgetsBinding.instance.addPostFrameCallback((_) {
              mapController.move(
                LatLng(searchResult!['lat'], searchResult!['lng']),
                15.0,
              );
            });
          } else {
            searchResult = null;
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Buat marker dari hasil pencarian
  void _updateMarkersFromResults(List<Map<String, dynamic>> locations) {
    List<Marker> newMarkers = [];

    for (var location in locations) {
      final String smart = location['smart'] ?? 'default';
      final bool isSelected =
          searchResult != null && searchResult!['name'] == location['name'];

      newMarkers.add(
        Marker(
          width: isSelected ? 50.0 : 40.0,
          height: isSelected ? 50.0 : 40.0,
          point: LatLng(location['lat'], location['lng']),
          child: GestureDetector(
            onTap: () {
              setState(() {
                searchResult = location;
              });
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.red : _getsmartColor(smart),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _getsmartIcon(smart),
                    color: isSelected ? Colors.red : _getsmartColor(smart),
                    size: isSelected ? 22.0 : 18.0,
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      location['name'],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    setState(() {
      _poiMarkers = newMarkers;
    });
  }

  void _performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchLocations(query);
      setState(() {
        searchQuery = query;
        isSearching = query.isNotEmpty;
      });
    });
  }

  Color _getsmartColor(String smart) {
    switch (smart.toLowerCase()) {
      case 'transportasi':
        return Colors.blue;
      case 'kesehatan':
        return Colors.red;
      case 'wisata':
        return Colors.green;
      case 'pemerintahan':
        return Colors.purple;
      case 'keuangan':
        return Colors.amber;
      case 'publik':
        return Colors.teal;
      case 'belanja':
        return Colors.orange;
      case 'pendidikan':
        return Colors.indigo;
      case 'ibadah':
        return Colors.cyan;
      case 'layanan':
        return Colors.pink;
      case 'kuliner':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  IconData _getsmartIcon(String smart) {
    switch (smart.toLowerCase()) {
      case 'transportasi':
        return Icons.directions_bus;
      case 'kesehatan':
        return Icons.local_hospital;
      case 'wisata':
        return Icons.landscape;
      case 'pemerintahan':
        return Icons.account_balance;
      case 'keuangan':
        return Icons.account_balance_wallet;
      case 'publik':
        return Icons.park;
      case 'belanja':
        return Icons.shopping_cart;
      case 'pendidikan':
        return Icons.school;
      case 'ibadah':
        return Icons.place_rounded;
      case 'layanan':
        return Icons.local_gas_station;
      case 'kuliner':
        return Icons.restaurant;
      default:
        return Icons.location_on;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Kota Sukabumi'),
        titleSpacing: 0,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map takes the full screen
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: 15.0,
              minZoom: 12.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                setState(() {
                  // Tutup info window yang terbuka
                  if (searchResult != null) {
                    searchResult = null;
                  }
                });
              },
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(sukabumiBounds1, sukabumiBounds2),
              ),
            ),
            children: [
              // Google Maps satellite layer
              TileLayer(
                urlTemplate:
                    'https://{s}.google.com/vt?lyrs=s,h&x={x}&y={y}&z={z}',
                subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                userAgentPackageName: 'com.example.sukabumismartcity',
              ),

              // Tampilkan marker hasil pencarian
              MarkerLayer(markers: _poiMarkers),

              // User location marker
              if (currentUserLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: currentUserLocation!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Floating search bar positioned with space from app bar - adjusted position
          Positioned(
            top: 16, // Reduced space from app bar to match the image
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari lokasi di Kota Sukabumi...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              _performSearch('');
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _performSearch,
              ),
            ),
          ),

          // Search results dropdown - adjusted position
          if (searchResults.isNotEmpty &&
              searchQuery.isNotEmpty &&
              searchResult == null)
            Positioned(
              top: 76, // Adjusted position below search bar
              left: 16,
              right: 16,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: searchResults.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final location = searchResults[index];
                    return ListTile(
                      leading: Icon(
                        _getsmartIcon(location['smart']),
                        color: _getsmartColor(location['smart']),
                      ),
                      title: Text(location['name']),
                      subtitle: Text(
                        location['description'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        setState(() {
                          searchResult = location;
                          mapController.move(
                            LatLng(location['lat'], location['lng']),
                            15.0,
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ),

          // Loading indicator
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Info card for selected location
          if (searchResult != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            _getsmartColor(searchResult!['smart'] ?? 'default')
                                .withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getsmartIcon(searchResult!['smart'] ?? 'default'),
                            color: _getsmartColor(
                                searchResult!['smart'] ?? 'default'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchResult!['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  searchResult!['smart'] ?? 'Default',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _getsmartColor(
                                        searchResult!['smart'] ?? 'default'),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                searchResult = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            searchResult!['description'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Koordinat: ${searchResult!['lat']}, ${searchResult!['lng']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        'https://www.google.com/maps/search/?api=1&query=${searchResult!['lat']},${searchResult!['lng']}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  icon: const Icon(Icons.map),
                                  label: const Text('Google Maps'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1565C0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        'https://www.google.com/maps/dir/?api=1&destination=${searchResult!['lat']},${searchResult!['lng']}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  icon: const Icon(Icons.directions),
                                  label: const Text('Rute'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
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
        ],
      ),
    );
  }
}
