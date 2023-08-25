/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlantingScreen extends StatefulWidget {
  const PlantingScreen({Key? key});

  @override
  _PlantingScreenState createState() => _PlantingScreenState();
}

class _PlantingScreenState extends State<PlantingScreen> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  final storage = FirebaseStorage.instance;
  List<Map<String, dynamic>> imageList = [];
  int visibleImageCount = 30;
  bool showMoreButton = true;

  @override
  void initState() {
    super.initState();
    fetchImageUrls().then((images) {
      if (mounted) {
        setState(() {
          imageList = images;
          showMoreButton = imageList.length > visibleImageCount;
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchImageUrls() async {
    final ListResult result = await storage.ref().child('data').listAll();
    final List<Reference> allFiles = result.items;

    List<Map<String, dynamic>> imageList = [];

    for (final ref in allFiles) {
      final url = await ref.getDownloadURL();
      final metadata = await ref.getMetadata();

      final imageInfo = {
        'url': url,
        'createdAt': metadata.timeCreated,
      };

      imageList.add(imageInfo);
    }

    imageList.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

    return imageList;
  }

  void loadMoreImages() {
    setState(() {
      visibleImageCount += 30;
      if (visibleImageCount >= imageList.length) {
        visibleImageCount = imageList.length;
        showMoreButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> visibleImages =
        imageList.take(visibleImageCount).toList(); // Get the visible images

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: visibleImages.length,
            itemBuilder: (context, index) {
              final imageUrl = visibleImages[index]['url'];
              final createdAt = visibleImages[index]['createdAt'];

              return GestureDetector(
                onTap: () {
                  // Handle image click here
                },
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(height: 7.0),
                    // Text('Created at: $createdAt'),
                  ],
                ),
              );
            },
          ),
        ),
        if (showMoreButton)
          ElevatedButton(
            onPressed: loadMoreImages,
            child: const Text('Load More'),
          ),
      ],
    );
  }
}
 */