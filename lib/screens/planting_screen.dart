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

  // เรียกใช้ฟังก์ชันเพื่อดึงชื่อไฟล์
  List<String> fileNames = imageUrls.map(getTimeStringFromUrl).toList();
  print(fileNames);

  // เรียงลำดับ URL ตามชื่อไฟล์
  imageUrls.sort();
  print(imageUrls);

  return imageUrls;
}

String getTimeStringFromUrl(String url) {
  // แบ่ง URL ด้วย '/'
  List<String> parts = url.split('%2F');

  // นับจำนวนส่วนที่ได้หลังจากการแบ่ง URL
  int numberOfParts = parts.length;

  // ถ้ามีส่วนมากกว่า 1 (ไม่นับส่วนแรกที่เป็น "https:")
  if (numberOfParts > 1) {
    // ดึงส่วนที่ 2 ถึงส่วนสุดท้าย
    List<String> fileNameParts = parts.sublist(1, numberOfParts);

    // ถ้ามี '?' ในส่วนสุดท้าย (ที่มีแท็ก 'token' และ 'alt')
    int questionMarkIndex = fileNameParts.last.indexOf('?');
    if (questionMarkIndex != -1) {
      // นำส่วนก่อน '?' เป็นชื่อไฟล์
      String fileName = fileNameParts.last.substring(0, questionMarkIndex);

      // แยกส่วนวันที่และเวลาจากชื่อไฟล์
      List<String> dateAndTimeParts = fileName.split('_');

      // ถ้ามีส่วนที่ต้องการหรือมีข้อผิดพลาด
      if (dateAndTimeParts.length >= 5) {
        // นำ 5 ส่วนแรก (รวมถึง '_' ที่อยู่ระหว่างส่วนที่ 4 และ 5) มารวมกัน
        String dateString = dateAndTimeParts.getRange(0, 3).join('/');
        String timeString = dateAndTimeParts.getRange(3, 5).join(':');

        // แยกวันที่และเวลา
        List<String> dateParts = dateString.split('/');
        List<String> timeParts = timeString.split(':');

        // สลับตำแหน่งระหว่างวันที่และเวลา
        String formattedString =
            'วันที่ ${dateParts[2]}/${dateParts[1]}/${dateParts[0]} \nเวลา ${timeParts[0]}:${timeParts[1]} น.';

        return formattedString;
      }
    }
  }

  // ถ้าไม่พบส่วนที่ต้องการหรือมีข้อผิดพลาด
  return '';
}

class ImagePage extends StatelessWidget {
  final String imageUrl;

  ImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '\n${getTimeStringFromUrl(imageUrl)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Expanded(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
