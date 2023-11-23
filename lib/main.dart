import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rmuti_iot/screens/home_screen.dart';
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
    return MaterialApp(
      home: HomeScreen(key: key),
    );
  }
}
