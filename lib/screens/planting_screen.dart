import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_provider.dart';

class PlantingScreen extends StatefulWidget {
  const PlantingScreen({super.key});

  @override
  _PlantingScreenState createState() => _PlantingScreenState();
}

class _PlantingScreenState extends State<PlantingScreen> {
  late PageController _pageController;
  late Future<List<String>> _imageUrls;
  late Timer _timer;
  int _currentPage = 0;

  Color toneColor = Colors.grey.shade800;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _imageUrls = getImageUrls();

    // รอให้ Future ดำเนินการเสร็จสมบูรณ์แล้วค่อยทำต่อ
    _imageUrls.then((imageUrls) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_currentPage < imageUrls.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }).catchError((error) {
      print('Error loading image URLs: $error');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: toneColor,
                    ),
                  ),
                  Text(
                    "การจัดเก็บรูปภาพ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: toneColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Text(
                      "${appProvider.time} น.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: _imageUrls,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // Cancel the timer if there's an error or no data
                      _timer.cancel();
                      return const Center(child: Text('ไม่พบรูปภาพ'));
                    } else {
                      List<String> imageUrls = snapshot.data!;
                      return PageView.builder(
                        controller: _pageController,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return ImagePage(imageUrl: imageUrls[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final String imageUrl;

  ImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}

Future<List<String>> getImageUrls() async {
  List<String> imageUrls = [];

  // กำหนด path ของโฟลเดอร์ใน Firebase Storage
  String path = 'data';

  // ดึงอ้างอิงของ Firebase Storage
  final Reference storageRef = FirebaseStorage.instance.ref().child(path);

  // ดึงรายการของไฟล์ในโฟลเดอร์
  final ListResult result = await storageRef.listAll();

  // นำ URL ของรูปภาพทั้งหมดมาเก็บไว้
  await Future.forEach(result.items, (Reference ref) async {
    String url = await ref.getDownloadURL();
    imageUrls.add(url);
  });

  // เรียงลำดับ URL ตามชื่อไฟล์
  imageUrls.sort();
  print(imageUrls);

  return imageUrls;
}

class MyImageWidget extends StatelessWidget {
  final String imageUrl;

  const MyImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}
