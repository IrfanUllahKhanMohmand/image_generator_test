import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const ScotaniApp());
}

class ScotaniApp extends StatelessWidget {
  const ScotaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DesignScreen(),
    );
  }
}

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  String? mainImage;
  List<String> generatedImages = [];
  final TextEditingController _promptController = TextEditingController();

  bool isLoading = false;
  double imageScale = 1.0; // Scale factor for resizing the main image

  Future<void> fetchGeneratedImages(String prompt) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {
          'query': prompt,
          'per_page': 10, // Limit to 3 images
        },
        options: Options(
          headers: {
            'Authorization': 'Client-ID $unsplashApiKey',
          },
        ),
      );

      final List<dynamic> results = response.data['results'];
      setState(() {
        generatedImages =
            results.map((item) => item['urls']['small'] as String).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to fetch images: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SCOTANI',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {}, // Add cart functionality
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/47231161?v=4'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Main Image Container
          Expanded(
            flex: 3,
            child: GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: mainImage != null
                    ? Transform.scale(
                        scale: imageScale,
                        child: Image.network(
                          mainImage!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : const Center(
                        child: Text(
                          'Select an Image',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              ),
            ),
          ),
          // Resize Slider (only visible when an image is selected)
          if (mainImage != null)
            Slider(
              value: imageScale,
              min: 0.5,
              max: 3.0,
              divisions: 25,
              label: imageScale.toStringAsFixed(1),
              activeColor: Colors.redAccent,
              onChanged: (double value) {
                setState(() {
                  imageScale = value;
                });
              },
            ),
          // Prompt Text Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _promptController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: 'Dragon anime art cool design',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.redAccent),
                        onPressed: () {
                          final prompt = _promptController.text.trim();
                          if (prompt.isNotEmpty) {
                            fetchGeneratedImages(prompt);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Prompt cannot be empty");
                          }
                        },
                      ),
              ),
            ),
          ),
          // Generated Images List
          Expanded(
            flex: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16.0),
              itemCount: generatedImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      mainImage = generatedImages[index];
                      imageScale =
                          1.0; // Reset scale when a new image is selected
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        generatedImages[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Next button functionality
              },
              child: const Text(
                'NEXT',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
