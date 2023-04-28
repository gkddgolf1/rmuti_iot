import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  var _lux = 0;
  var _time = '';

  // sensor ตัวสีเหลือง && sensor สี
  var _status1 = 0;
  var _status2 = 0;

  bool _halfDay = false;
  bool _fullDay = false;
  bool _statusAuto = false;
  bool isSwitched = false;

  bool _isLeftPressed = false;
  bool _isRightPressed = false;

  // set time start
  DateTime datestart = DateTime(21, 1, 1);
  DateTime timestart = DateTime(11, 22);
  // set time stop
  DateTime datestop = DateTime(22, 8, 3);
  DateTime timestop = DateTime(15, 55);

  @override
  void initState() {
    super.initState();
    _loadSwitchState();

    // _statusAuto
    databaseReference
        .child('ESP32/setControl/setAutoMode/motor')
        .onValue
        .listen((event) {
      int statusAuto = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _statusAuto = (statusAuto == 1);
        });
      }
    });

    // isSwitched
    databaseReference
        .child('ESP32/setControl/setTimerMode/motor')
        .onValue
        .listen((event) {
      int settime = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          isSwitched = (settime == 1);
        });
      }
    });

    // _halfDay
    databaseReference
        .child('ESP32/setControl/MOTOR/setAuto/halfDay')
        .onValue
        .listen(
      (event) {
        int halfday = (event.snapshot.value as int);
        if (mounted) {
          setState(() {
            if (halfday == 1000) {
              _halfDay = true;
            } else {
              _halfDay = false;
            }
          });
        }
      },
    );

    // _fullDay
    databaseReference
        .child('ESP32/setControl/MOTOR/setAuto/fullDay')
        .onValue
        .listen(
      (event) {
        int fullday = (event.snapshot.value as int);
        if (mounted) {
          setState(() {
            if (fullday == 1500) {
              _fullDay = true;
            } else {
              _fullDay = false;
            }
          });
        }
      },
    );

    // BH1750
    databaseReference.child('ESP32/BH1750/Lux').onValue.listen((event) {
      int lux = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _lux = lux;
        });
      }
    });

    // RTC1307
    databaseReference.child('ESP32/RTC1307/Time').onValue.listen((event) {
      var time = event.snapshot.value;
      if (mounted) {
        setState(() {
          _time = time.toString();
        });
      }
    });

    // E18-D80NK (sensor สีตัวเหลือง)
    databaseReference.child('ESP32/E18-D80NK/status').onValue.listen((event) {
      int status1 = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _status1 = status1;
        });
      }
    });

    // TCS-34725 (sensor สี)
    databaseReference.child('ESP32/TCS-34725/status').onValue.listen((event) {
      int status2 = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _status2 = status2;
        });
      }
    });
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _statusAuto = prefs.getBool('_statusAuto') ?? false;
      isSwitched = prefs.getBool('isSwitched') ?? false;
      _halfDay = prefs.getBool('_halfDay') ?? false;
      _fullDay = prefs.getBool('_fullDay') ?? false;
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // ฟังก์ชันส่งค่ามอเตอร์
  void _sendData() {
    int left = _isLeftPressed ? 1 : 0;
    int right = _isRightPressed ? 1 : 0;
    databaseReference.child('ESP32/setControl/MOTOR/left').set(left);
    databaseReference.child('ESP32/setControl/MOTOR/right').set(right);
  }

  // ฟังก์ชันโชว์ ui นาฬิกาเมื่อกด
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

  //ฟังก์ชันความสมดุลแสดง Text ตามค่าที่กำหนด
  String displayText() {
    String textToDisplay = '';
    if (_lux <= 7000) {
      textToDisplay = "ความเข้มแสงน้อย";
    } else if (_lux > 7000 && _lux < 15000) {
      textToDisplay = 'ความเข้มแสงปกติ';
    } else if (_lux > 15000) {
      textToDisplay = 'ความเข้มแสงมาก';
    }
    return textToDisplay;
  }

  String statusCurtain() {
    String statusDisplay = '';
    if (_status1 == 1) {
      statusDisplay = "ปิด";
    } else if (_status2 == 1) {
      statusDisplay = "เปิด";
    } else if (_status1 == 0 && _status2 == 0) {
      statusDisplay = "กำลังทำงาน";
    }
    return statusDisplay;
  }

  @override
  Widget build(BuildContext context) {
    // เปลี่ยนสีข้อความสีส่งมาจากฟังก์ชัน displayText()
    String message = displayText();
    Color textColor = Colors.black;
    if (message == "ความเข้มแสงน้อย") {
      textColor = Colors.orange;
    } else if (message == "ความเข้มแสงปกติ") {
      textColor = Colors.green;
    } else if (message == "ความเข้มแสงมาก") {
      textColor = Colors.red;
    }

    // เปลี่ยนสีข้อความสีส่งมาจากฟังก์ชัน statusCurtain()
    String statuscurtain = statusCurtain();
    Color statuscurtainColor = Colors.black;
    if (statuscurtain == "ปิด") {
      statuscurtainColor = Colors.green;
    } else if (statuscurtain == "เปิด") {
      statuscurtainColor = Colors.green;
    } else if (statuscurtain == "กำลังทำงาน") {
      statuscurtainColor = Colors.orange;
    }

    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheel = _lux.toDouble();
    if (wheel >= 1 && wheel <= 100) {
      wheel = wheel / 100;
    } else if (wheel > 100 && wheel <= 1000) {
      wheel = wheel / 1000;
    } else if (wheel > 1000) {
      wheel = wheel / 10000;
    }

    //ขนาด TextField
    double screenWidth;
    screenWidth = MediaQuery.of(context).size.width;

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
                      color: Color.fromARGB(255, 228, 142, 14),
                    ),
                  ),
                  const Text(
                    "Light intensity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                      _time.toString(),
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
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        _wheelCircle(
                            percentWheel: wheel,
                            textTitel: "$_lux",
                            textLong: "Lux"),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Light intensity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "ความสมดุล: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              message,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "สถานะม่านบังแสง: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              statuscurtain,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: statuscurtainColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundedButton(title: 'GENERAL', isActive: true),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: const [
                                Text(
                                  'Curtain control',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Tooltip(
                                  message: 'เลื่อนซ้ายปิด - เลื่อนขวาเปิด',
                                  triggerMode:
                                      TooltipTriggerMode.tap, // tooltip text
                                  child: Icon(Icons.help_outline),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _isLeftPressed = true;
                                    _sendData();
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _isLeftPressed = false;
                                    _sendData();
                                  });
                                },
                                child: CustomPaint(
                                  size: const Size(90, 70),
                                  painter: TriangleButtonPainter(
                                      isLeft: true, isPressed: _isLeftPressed),
                                ),
                              ),
                              const SizedBox(width: 50),
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _isRightPressed = true;
                                    _sendData();
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _isRightPressed = false;
                                    _sendData();
                                  });
                                },
                                child: CustomPaint(
                                  size: const Size(90, 70),
                                  painter: TriangleButtonPainter(
                                      isLeft: false,
                                      isPressed: _isRightPressed),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Auto Curtain',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Tooltip(
                                      message: 'เปิด-ปิดม่านเมื่อแสงพอแล้ว',
                                      triggerMode: TooltipTriggerMode
                                          .tap, // tooltip text
                                      child: Icon(Icons.help_outline),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_statusAuto == false) {
                                              setState(() {
                                                _halfDay = true;
                                                _saveSwitchState(
                                                    '_halfDay', true);
                                              });
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/fullDay')
                                                  .set(0);
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/halfDay')
                                                  .set(1000);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _halfDay
                                                ? const Color.fromARGB(
                                                    255, 228, 142, 14)
                                                : Colors.grey,
                                          ),
                                          child: const Text('ครึ่งวัน'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_statusAuto == false) {
                                              setState(() {
                                                _fullDay = true;
                                                _saveSwitchState(
                                                    '_fullDay', true);
                                              });
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/halfDay')
                                                  .set(0);
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/fullDay')
                                                  .set(1500);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _fullDay
                                                ? const Color.fromARGB(
                                                    255, 228, 142, 14)
                                                : Colors.grey,
                                          ),
                                          child: const Text('เต็มวัน'),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FlutterSwitch(
                                              width: 100,
                                              height: 40,
                                              valueFontSize: 25,
                                              toggleSize: 45.0,
                                              value: _statusAuto,
                                              borderRadius: 30.0,
                                              padding: 8.0,
                                              showOnOff: true,
                                              onToggle: (value) {
                                                if (_halfDay) {
                                                  setState(() {
                                                    _statusAuto = value;
                                                    _saveSwitchState(
                                                        '_statusAuto', value);
                                                  });
                                                  int statusAuto =
                                                      _statusAuto ? 1 : 0;
                                                  //send values back to Firebase to order watering
                                                  databaseReference
                                                      .child(
                                                          'ESP32/setControl/setAutoMode/motor')
                                                      .set(statusAuto);
                                                } else if (_fullDay) {
                                                  setState(() {
                                                    _statusAuto = value;
                                                    _saveSwitchState(
                                                        '_statusAuto', value);
                                                  });
                                                  int statusAuto =
                                                      _statusAuto ? 1 : 0;
                                                  //send values back to Firebase to order watering
                                                  databaseReference
                                                      .child(
                                                          'ESP32/setControl/setAutoMode/motor')
                                                      .set(statusAuto);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Set Time',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Tooltip(
                                      message: 'ตั้งเวลาเปิด-ปิดม่าน',
                                      triggerMode: TooltipTriggerMode
                                          .tap, // tooltip text
                                      child: Icon(Icons.help_outline),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: FlutterSwitch(
                                  width: 100,
                                  height: 40,
                                  valueFontSize: 25,
                                  toggleSize: 45.0,
                                  value: isSwitched,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  onToggle: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      _saveSwitchState('isSwitched', value);
                                    });
                                    int setTime = isSwitched ? 1 : 0;

                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setTimerMode/motor')
                                        .set(setTime);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundedButton(title: 'Set Time', isActive: true),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: isSwitched,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Set Time On',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Set Time Off',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: SizedBox(
                                    width: screenWidth * 0.42,
                                    child: CupertinoButton(
                                      // Display a CupertinoDatePicker in time picker mode.
                                      onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: timestart,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => timestart = newTime);
                                          },
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Time : ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            '${timestart.hour} : ${timestart.minute}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: SizedBox(
                                    width: screenWidth * 0.42,
                                    child: CupertinoButton(
                                      // Display a CupertinoDatePicker in time picker mode.
                                      onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: timestop,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => timestop = newTime);
                                          },
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Time : ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            '${timestop.hour} : ${timestop.minute}',
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
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      int hour = timestart.hour;
                                      int minute = timestart.minute;

                                      databaseReference
                                          .child(
                                              'ESP32/setControl/MOTOR/setTimeStart/hour')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/MOTOR/setTimeStart/minute')
                                          .set(minute);
                                    },
                                    child: const Text('Set Start'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      int hour = timestop.hour;
                                      int minute = timestop.minute;

                                      databaseReference
                                          .child(
                                              'ESP32/setControl/MOTOR/setTimeStop/hour')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/MOTOR/setTimeStop/minute')
                                          .set(minute);
                                    },
                                    child: const Text('Set Stop'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
        color: isActive
            ? const Color.fromARGB(255, 228, 142, 14)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color.fromARGB(255, 228, 142, 14)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _wheelCircle({
    required double percentWheel,
    required String textTitel,
    required String textLong,
  }) {
    return CircularPercentIndicator(
      radius: 120,
      lineWidth: 20,
      percent: percentWheel,
      backgroundWidth: 10,
      backgroundColor: Colors.deepPurple.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      rotateLinearGradient: true,
      maskFilter: const MaskFilter.blur(BlurStyle.solid, 8.0),
      linearGradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 180, 138, 22),
          Color.fromARGB(255, 207, 156, 13),
          Color.fromARGB(255, 255, 187, 0),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textTitel,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            textLong,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleButtonPainter extends CustomPainter {
  final bool isLeft;
  final bool isPressed;

  TriangleButtonPainter({required this.isLeft, required this.isPressed});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color =
          isPressed ? const Color.fromARGB(255, 228, 142, 14) : Colors.grey
      ..style = PaintingStyle.fill;

    Path path = Path();
    if (isLeft) {
      path.moveTo(size.width, size.height);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TriangleButtonPainter oldDelegate) {
    return isPressed != oldDelegate.isPressed;
  }
}
