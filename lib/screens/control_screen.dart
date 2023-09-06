import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/buttons.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Color toneColor = Colors.grey.shade800;

  var _time = '';

  Color textColor = Colors.grey.shade800;

  // Motor
  String startMotor = '0';
  String stopMotor = '0';

  // Pump
  String startPump = '0';
  String stopPump = '0';

  // NPK
  String startNPK = '0';
  String stopNPK = '0';

  DateTime date = DateTime(22, 8, 3);
  DateTime time = DateTime(15, 55);

  @override
  void initState() {
    super.initState();

    // RTC1307 == Time
    databaseReference.child('ESP32/views/RTC1307/Time').onValue.listen((event) {
      var time = event.snapshot.value;
      if (mounted) {
        setState(() {
          _time = time.toString();
        });
      }
    });

    /* -----------------------------Motor---------------------------------------- */
    // StartHourMotor
    databaseReference
        .child('ESP32/setControl/MOTOR/setTimeStart')
        .onValue
        .listen((event) {
      String startmotor = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          startMotor = startmotor;
        });
      }
    });
    // StopHourMotor
    databaseReference
        .child('ESP32/setControl/MOTOR/setTimeStop')
        .onValue
        .listen((event) {
      String stopmotor = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          stopMotor = stopmotor;
        });
      }
    });

/* -----------------------------Pump---------------------------------------- */
    // StartHourPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStart')
        .onValue
        .listen((event) {
      String startpump = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          startPump = startpump;
        });
      }
    });
    // StopHourPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStop')
        .onValue
        .listen((event) {
      String stoppump = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          stopPump = stoppump;
        });
      }
    });
    // StopMinPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStop')
        .onValue
        .listen((event) {
      String stoppump = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          stopPump = stoppump;
        });
      }
    });
    /* -----------------------------NPK---------------------------------------- */
    /* // StartHourPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStart')
        .onValue
        .listen((event) {
      String startNPK = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          startNPK = startNPK;
        });
      }
    });
    // StartMinPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStart')
        .onValue
        .listen((event) {
      String startNPK = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          startNPK = startNPK;
        });
      }
    });
    // StopHourPump
    /*  databaseReference
        .child('ESP32/setControl/NPK/setTimeStop')
        .onValue
        .listen((event) {
      String stopNPK = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          stopNPK = stopNPK;
        });
      }
    }); */
    // StopMinPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStop')
        .onValue
        .listen((event) {
      String stopNPK = (event.snapshot.value as String);
      if (mounted) {
        setState(() {
          stopNPK = stopNPK;
        });
      }
    }); */
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
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
                    "การตั้งค่า",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: toneColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Text(
                      "$_time น.",
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
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundedButton(title: 'ตั้งค่า', isActive: true),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'ตั้งวันที่',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: SizedBox(
                                  child: CupertinoButton(
                                    // Display a CupertinoDatePicker in time picker mode.
                                    onPressed: () => _showDialog(
                                      CupertinoDatePicker(
                                        initialDateTime: date,
                                        mode: CupertinoDatePickerMode.date,
                                        use24hFormat: true,
                                        // This is called when the user changes the time.
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(() => date = newDate);
                                        },
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${date.day}-${date.month}-${date.year}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'ตั้งเวลา',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: SizedBox(
                                  child: CupertinoButton(
                                    // Display a CupertinoDatePicker in time picker mode.
                                    onPressed: () => _showDialog(
                                      CupertinoDatePicker(
                                        initialDateTime: time,
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        // This is called when the user changes the time.
                                        onDateTimeChanged: (DateTime newTime) {
                                          setState(() => time = newTime);
                                        },
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${time.hour}:${time.minute} น.",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: elevatedButton(
                                  text: "ยืนยัน",
                                  colors: [
                                    Colors.grey.shade700,
                                    Colors.grey.shade700,
                                    Colors.grey.shade700,
                                  ],
                                  onPressed: () {
                                    int day = date.day;
                                    int month = date.month;
                                    int year = date.year;

                                    String setDate = '$day-$month-$year';
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/date')
                                        .set(setDate);

                                    int hour = time.hour;
                                    int minute = time.minute;
                                    String setTime = '$hour:$minute';
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/time')
                                        .set(setTime);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'การตั้งเวลารดน้ำ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'เริ่ม: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                  Text(
                                    '$startPump น.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'หยุด: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                Text(
                                  '$stopPump น.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'การตั้งเวลาให้ปุ๋ย',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'เริ่ม: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                  Text(
                                    '$startNPK น.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'หยุด: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                Text(
                                  '$stopNPK น.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'ตั้งเวลารับแสง',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'เริ่ม: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                  Text(
                                    '$startMotor น.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'หยุด: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                Text(
                                  '$stopMotor น.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundedButton({
    required String title,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 32,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade600 : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }
}
