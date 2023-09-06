import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlantingScreen extends StatefulWidget {
  const PlantingScreen({super.key});

  @override
  _PlantingScreenState createState() => _PlantingScreenState();
}

class _PlantingScreenState extends State<PlantingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Map<String, dynamic>> imageList = [];
  int visibleImageCount = 5;
  bool showMoreButton = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      setState(() {
        isLoading = true;
      });

      final ListResult result = await _storage.ref().child('data').list();
      final List<Reference> allFiles = result.items;

      List<Map<String, dynamic>> fetchedImages = [];

      for (final ref in allFiles) {
        final url = await ref.getDownloadURL();
        final metadata = await ref.getMetadata();

        final imageInfo = {
          'url': url,
          'createdAt': metadata.timeCreated,
        };

        fetchedImages.add(imageInfo);
      }

      fetchedImages.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

      setState(() {
        imageList = fetchedImages;
        isLoading = false;
        showMoreButton = imageList.length > visibleImageCount;
      });
    } catch (e) {
      print('Error fetching image URLs: $e');
      // Handle the error (e.g., show a snackbar to the user)
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMoreImages() {
    setState(() {
      visibleImageCount += 5;
      if (visibleImageCount >= imageList.length) {
        visibleImageCount = imageList.length;
        showMoreButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user != null) {
      // User is authenticated, allow access to images.
    } else {
      // User is not authenticated, handle accordingly (e.g., show a login screen).
    }

    final List<Map<String, dynamic>> visibleImages =
        imageList.take(visibleImageCount).toList(); // Get the visible images

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    "ภาพแปลงปลูก",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
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
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),

                        // Text('Created at: $createdAt'),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading)
                const CircularProgressIndicator()
              else if (showMoreButton)
                ElevatedButton(
                  onPressed: loadMoreImages,
                  child: const Text('Load More'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
