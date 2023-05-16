import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rmuti_iot/screens/control_screen.dart';
import 'package:rmuti_iot/screens/light_screen.dart';
import 'package:rmuti_iot/screens/soil_moisture_Screen.dart';
import 'package:rmuti_iot/screens/fertilizer_screen.dart';

import 'screens/planting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Green House',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 135,
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Image.asset(
                        'images/banner.png',
                        scale: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Smart Farm',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'SERVICES',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cardMenu(
                          onTap: () {
                            int sendsoil = 1;
                            databaseReference
                                .child('ESP32/setControl/view/soil')
                                .set(sendsoil);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SoilMoistureScreen(),
                              ),
                            ).then((_) {
                              int sendsoil = 0;
                              databaseReference
                                  .child('ESP32/setControl/view/soil')
                                  .set(sendsoil);
                            });
                          },
                          icon: 'images/humidity.png',
                          title: 'ความชื้นดิน',
                        ),
                        _cardMenu(
                          onTap: () {
                            int sendNPK = 1;
                            databaseReference
                                .child('ESP32/setControl/view/npk')
                                .set(sendNPK);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FertilizerScreen(),
                              ),
                            ).then((_) {
                              int sendNPK = 0;
                              databaseReference
                                  .child('ESP32/setControl/view/npk')
                                  .set(sendNPK);
                            });
                          },
                          icon: 'images/fertilizer.png',
                          title: 'การให้ปุ๋ย',
                          //color: Colors.indigoAccent,
                          //fontColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cardMenu(
                          onTap: () {
                            int sendLux = 1;
                            databaseReference
                                .child('ESP32/setControl/view/lux')
                                .set(sendLux);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LightScreen(),
                              ),
                            ).then((_) {
                              int sendLux = 0;
                              databaseReference
                                  .child('ESP32/setControl/view/lux')
                                  .set(sendLux);
                            });
                          },
                          icon: 'images/sun.png',
                          title: 'การให้แสง',
                        ),
                        _cardMenu(
                          onTap: () {
                            int sendPlant = 1;
                            databaseReference
                                .child('ESP32/setControl/view/plant')
                                .set(sendPlant);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PlantingScreen(),
                              ),
                            ).then((_) {
                              int sendPlant = 0;
                              databaseReference
                                  .child('ESP32/setControl/view/plant')
                                  .set(sendPlant);
                            });
                          },
                          icon: 'images/picture.png',
                          title: 'ดูแปลงปลูก',
                          //color: Colors.indigoAccent,
                          //fontColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cardMenu(
                          onTap: () {
                            int sendSetting = 1;
                            databaseReference
                                .child('ESP32/setControl/view/setting')
                                .set(sendSetting);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingScreen(),
                              ),
                            ).then((_) {
                              int sendSetting = 0;
                              databaseReference
                                  .child('ESP32/setControl/view/setting')
                                  .set(sendSetting);
                            });
                          },
                          icon: 'images/control.png',
                          title: 'การตั้งค่า',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardMenu({
    required String title,
    required String icon,
    VoidCallback? onTap,
    Color color = Colors.white,
    Color fontColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.asset(icon),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
            )
          ],
        ),
      ),
    );
  }
}
