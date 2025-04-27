import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailNewsScreen extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final String imageUrl;

  const DetailNewsScreen({
    Key? key,
    required this.title,
    required this.date,
    required this.content,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: const Color(0xFF008080), // Teal
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Berita
                  if (imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('Gagal memuat gambar'),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Judul
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Tanggal
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  // Konten Berita
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      final cleanedContent = content.trim();

                      if (cleanedContent.isEmpty) {
                        return const Text(
                          'Konten berita tidak tersedia.',
                          style: TextStyle(fontSize: 16),
                        );
                      }

                      try {
                        return Html(
                          data: cleanedContent,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: LineHeight(1.5),
                              color: Colors.black87,
                            ),
                          },
                        );
                      } catch (e) {
                        return Text(
                          'Gagal memuat konten berita.\nError: $e',
                          style: const TextStyle(
                              color: Colors.red, fontSize: 16),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
