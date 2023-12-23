import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rmuti_iot/screens/home_screen.dart';
import 'package:rmuti_iot/screens/planting_screen.dart';
import 'package:rmuti_iot/services/app_provider.dart';
import 'package:provider/provider.dart';

/* const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyBRTkK1mjO90zTCQSpKSts562hfpUwl2gk',
  appId: '1:54519034830:android:8547f42c9cf3903c94f19f',
  projectId: 'projectgreenhouse-6f492',
  messagingSenderId: '54519034830',
  storageBucket: 'gs://projectgreenhouse-6f492.appspot.com/data',
); */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  /* // Automatically sign in anonymously
  final userCredential = await FirebaseAuth.instance.signInAnonymously();
  final uid = userCredential.user!.uid;

  print('Sign in Success: $uid'); */

  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(context),
    child: const MaterialApp(
      // Wrap with MaterialApp
      title: 'My App',
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: HomeScreen(key: key),
      home: HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  late Future<List<String>> _imageUrls;
  late Timer _timer;
  int _currentPage = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage Image Viewer'),
      ),
      body: FutureBuilder<List<String>>(
        future: _imageUrls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Cancel the timer if there's an error or no data
            _timer.cancel();
            return const Center(child: Text('No images found.'));
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
