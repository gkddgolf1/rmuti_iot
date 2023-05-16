import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PlantingScreen extends StatefulWidget {
  const PlantingScreen({Key? key});

  @override
  _PlantingScreenState createState() => _PlantingScreenState();
}

class _PlantingScreenState extends State<PlantingScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = FirebaseStorage.instance.ref().child('data');
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    ListResult result = await ref.listAll();
    result.items.forEach((Reference ref) async {
      String url = await ref.getDownloadURL();
      setState(() {
        imageUrls.add(url);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void _onImageTap(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(imageUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Gallery'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: List.generate(imageUrls.length, (index) {
                return GestureDetector(
                  onTap: () => _onImageTap(imageUrls[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  const ImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Large Image'),
      ),
      body: Column(
        children: [
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          const Center(
            child: Text('สวัสดีครับ'),
          ),
        ],
      ),
    );
  }
}
