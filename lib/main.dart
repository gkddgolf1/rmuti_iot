import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:rmuti_iot/screens/home_screen.dart';
import 'package:rmuti_iot/services/app_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: '6Le5WAQoAAAAAKAkPy1XsS4hlTQhAaLp75sJg5Nn');

  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(context),
    child: const MyApp(),
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
