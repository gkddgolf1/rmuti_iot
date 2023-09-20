import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmuti_iot/screens/planting_screen.dart';
import 'package:rmuti_iot/screens/soil_moisture_Screen.dart';

import 'control_screen.dart';
import 'fertilizer_screen.dart';
import 'light_screen.dart';

import 'package:provider/provider.dart';

import 'package:rmuti_iot/services/app_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
  }

  Color textColor = Colors.grey.shade800;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${appProvider.temperature} °C',
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
                              '${appProvider.humidity} %',
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1,
                        color: Color.fromARGB(255, 204, 204, 204),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'เมนู',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
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
