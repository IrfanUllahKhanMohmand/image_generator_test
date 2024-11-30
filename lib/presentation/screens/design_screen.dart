import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/image_bloc.dart';
import '../bloc/image_event.dart';
import '../bloc/image_state.dart';

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  String? mainImage; // Stores the selected main image
  double imageScale = 1.0; // Scale factor for resizing the main image
  final TextEditingController _promptController = TextEditingController();

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
                  onPressed: () {}, // Placeholder for cart functionality
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/47231161?v=4',
                  ),
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
          // Prompt TextField
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
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.redAccent),
                  onPressed: () {
                    final query = _promptController.text.trim();
                    if (query.isNotEmpty) {
                      context.read<ImageBloc>().add(FetchImagesEvent(query));
                    }
                  },
                ),
              ),
            ),
          ),
          // Generated Images List
          Expanded(
            flex: 2,
            child: BlocBuilder<ImageBloc, ImageState>(
              builder: (context, state) {
                if (state is ImageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ImageLoaded) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            mainImage = state.images[index];
                            imageScale = 1.0; // Reset scale on selection
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
                              state.images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ImageError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'Enter a prompt to fetch images',
                    style: TextStyle(color: Colors.white70),
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
                // Placeholder for the next button functionality
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
