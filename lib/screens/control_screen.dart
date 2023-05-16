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

  var _time = '';

  // Motor
  var startHourMotor = 0;
  var startMinMotor = 0;
  var stopHourMotor = 0;
  var stopMinMotor = 0;

  // Pump
  var startHourPump = 0;
  var startMinPump = 0;
  var stopHourPump = 0;
  var stopMinPump = 0;

  // NPK
  var startHourNPK = 0;
  var startMinNPK = 0;
  var stopHourNPK = 0;
  var stopMinNPK = 0;

  DateTime date = DateTime(22, 8, 3);
  DateTime time = DateTime(15, 55);

  @override
  void initState() {
    super.initState();

    // RTC1307 == Time
    databaseReference.child('ESP32/RTC1307/Time').onValue.listen((event) {
      var time = event.snapshot.value;
      if (mounted) {
        setState(() {
          _time = time.toString();
        });
      }
    });
    /* // RTC1307 == Date
    databaseReference.child('ESP32/RTC1307/Date').onValue.listen((event) {
      var date = event.snapshot.value;
      if (mounted) {
        setState(() {
          _date = date.toString();
        });
      }
    }); */

    /* -----------------------------Motor---------------------------------------- */
    // StartHourMotor
    databaseReference
        .child('ESP32/setControl/MOTOR/setTimeStart/hour')
        .onValue
        .listen((event) {
      int starthourmotor = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          startHourMotor = starthourmotor;
        });
      }
    });
    // StartMinMotor
    databaseReference
        .child('ESP32/setControl/MOTOR/setTimeStart/minute')
        .onValue
        .listen((event) {
      int startminmotor = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          startMinMotor = startminmotor;
        });
      }
    });
    // StopHourMotor
    databaseReference
        .child('ESP32/setControl/MOTOR/setTimeStop/hour')
        .onValue
        .listen((event) {
      int stophourmotor = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          stopHourMotor = stophourmotor;
        });
      }
    });
    // StopMinMotor
    databaseReference
        .child('ESP32/setControl/MOTOR/setTimeStop/minute')
        .onValue
        .listen((event) {
      int stopminmotor = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          stopMinMotor = stopminmotor;
        });
      }
    });
/* -----------------------------Pump---------------------------------------- */
    // StartHourPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStart/hour')
        .onValue
        .listen((event) {
      int starthourpump = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          startHourPump = starthourpump;
        });
      }
    });
    // StartMinPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStart/minute')
        .onValue
        .listen((event) {
      int startminpump = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          startMinPump = startminpump;
        });
      }
    });
    // StopHourPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStop/hour')
        .onValue
        .listen((event) {
      int stophourpump = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          stopHourPump = stophourpump;
        });
      }
    });
    // StopMinPump
    databaseReference
        .child('ESP32/setControl/PUMP/setTimeStop/minute')
        .onValue
        .listen((event) {
      int stopminpump = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          stopMinPump = stopminpump;
        });
      }
    });
    /* -----------------------------NPK---------------------------------------- */
    // StartHourPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStart/hour')
        .onValue
        .listen((event) {
      int starthourNPK = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          startHourNPK = starthourNPK;
        });
      }
    });
    // StartMinPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStart/minute')
        .onValue
        .listen((event) {
      int startminNPK = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          startMinNPK = startminNPK;
        });
      }
    });
    // StopHourPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStop/hour')
        .onValue
        .listen((event) {
      int stophourNPK = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          stopHourNPK = stophourNPK;
        });
      }
    });
    // StopMinPump
    databaseReference
        .child('ESP32/setControl/NPK/setTimeStop/minute')
        .onValue
        .listen((event) {
      int stopminNPK = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          stopMinNPK = stopminNPK;
        });
      }
    });
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
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.indigo,
                    ),
                  ),
                  const Text(
                    "Setting",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                        _roundedButton(title: 'Setting', isActive: true),
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'Set Date',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
                                          style: const TextStyle(
                                            fontSize: 20,
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'Set Time',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
                                          style: const TextStyle(
                                            fontSize: 20,
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
                                  text: "Set Start",
                                  colors: [
                                    const Color.fromARGB(255, 184, 116, 15),
                                    const Color.fromARGB(255, 201, 125, 12),
                                    const Color.fromARGB(255, 247, 150, 4)
                                  ],
                                  onPressed: () {
                                    int day = date.day;
                                    int month = date.month;
                                    int year = date.year;
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/day')
                                        .set(day);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/month')
                                        .set(month);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/year')
                                        .set(year);

                                    int hour = time.hour;
                                    int minute = time.minute;
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/hour')
                                        .set(hour);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setDateTime/minute')
                                        .set(minute);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundedButton(
                            title: 'Set Time Sprinkle', isActive: true),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Start: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '$startHourPump : $startMinPump น.',
                                    style: const TextStyle(
                                      fontSize: 20,
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
                                const Text(
                                  'Stop: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$stopHourPump : $stopMinPump น.',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundedButton(
                            title: 'Set Time Fertilizer', isActive: true),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Start: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '$startHourNPK : $startMinNPK น.',
                                    style: const TextStyle(
                                      fontSize: 20,
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
                                const Text(
                                  'Stop: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$stopHourNPK : $stopMinNPK น.',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundedButton(
                            title: 'Set Time Curtain', isActive: true),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Start: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$startHourMotor : $startMinMotor น.',
                                    style: const TextStyle(
                                      fontSize: 20,
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
                                const Text(
                                  'Stop: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$stopHourMotor : $stopMinMotor น.',
                                  style: const TextStyle(
                                    fontSize: 20,
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
        color: isActive ? Colors.indigo : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.indigo),
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
