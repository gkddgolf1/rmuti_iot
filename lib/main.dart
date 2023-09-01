import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  dynamic _temp;
  dynamic _hum;

  Color textColor = Colors.grey.shade800;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    final databaseReference = FirebaseDatabase.instance.ref();

    databaseReference
        .child('ESP32/views/SHT31/temperature')
        .onValue
        .listen((event) {
      dynamic temperature = (event.snapshot.value as dynamic);
      if (mounted) {
        setState(() {
          _temp = temperature;
        });
      }
    });
    databaseReference
        .child('ESP32/views/SHT31/humidity')
        .onValue
        .listen((event) {
      dynamic humidity = (event.snapshot.value as dynamic);
      if (mounted) {
        setState(() {
          _hum = humidity;
        });
      }
    });
  }

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
              Center(
                child: Text(
                  'Green House',
                  style: GoogleFonts.bebasNeue(fontSize: 30),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    /* Center(
                      child: Image.asset(
                        'images/banner.png',
                        scale: 1.3,
                      ),
                    ), 
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Smart Farm',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),*/
                    //const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$_temp °C',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: textColor,
                              ),
                            ),
                            Image.asset(
                              'images/temp.png',
                              height: 30,
                              //color: Colors.grey[800],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '$_hum %',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: textColor,
                              ),
                            ),
                            Image.asset(
                              'images/hum.png',
                              height: 30,
                              //color: Colors.grey[800],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'SERVICES',
                      style: TextStyle(
                        color: textColor,
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
                          colors: textColor,
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
                          colors: textColor,
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
                          colors: textColor,
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
                          colors: textColor,
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
                          colors: textColor,
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
    required Color colors,
    VoidCallback? onTap,
    Color color = Colors.white,
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
              style: TextStyle(fontWeight: FontWeight.bold, color: colors),
            )
          ],
        ),
      ),
    );
  }
}
