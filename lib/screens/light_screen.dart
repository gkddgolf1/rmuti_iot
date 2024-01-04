import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../buttons/buttons.dart';
import '../services/app_provider.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Color toneColor = Colors.grey.shade800;

  bool _statusAuto = false;
  bool isSwitched = false;

  bool _isLeftPressed = false;
  bool _isRightPressed = false;

  // set time start
  DateTime timestart = DateTime(11, 22);
  // set time stop
  DateTime timestop = DateTime(15, 55);

  @override
  void initState() {
    super.initState();
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
  String displayText(AppProvider appProvider) {
    String textToDisplay = '';
    if (appProvider.lux <= 7000) {
      textToDisplay = "ความเข้มแสงน้อย";
    } else if (appProvider.lux > 7000 && appProvider.lux < 15000) {
      textToDisplay = 'ความเข้มแสงปกติ';
    } else if (appProvider.lux > 15000) {
      textToDisplay = 'ความเข้มแสงมาก';
    }
    return textToDisplay;
  }

  String statusCurtain(AppProvider appProvider) {
    String statusDisplay = '';
    if (appProvider.statusOpen == 1) {
      statusDisplay = "ปิด";
    } else if (appProvider.statusOff == 1) {
      statusDisplay = "เปิด";
    } else if (appProvider.statusOpen == 0 && appProvider.statusOff == 0) {
      statusDisplay = "กำลังทำงาน";
    }
    return statusDisplay;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    // เปลี่ยนสีข้อความสีส่งมาจากฟังก์ชัน displayText()
    String message = displayText(appProvider);
    Color textColor = Colors.black;
    if (message == "ความเข้มแสงน้อย") {
      textColor = Colors.orange;
    } else if (message == "ความเข้มแสงปกติ") {
      textColor = Colors.green;
    } else if (message == "ความเข้มแสงมาก") {
      textColor = Colors.red;
    }

    // เปลี่ยนสีข้อความสีส่งมาจากฟังก์ชัน statusCurtain()
    String statuscurtain = statusCurtain(appProvider);
    Color statuscurtainColor = Colors.black;
    if (statuscurtain == "ปิด") {
      statuscurtainColor = Colors.green;
    } else if (statuscurtain == "เปิด") {
      statuscurtainColor = Colors.green;
    } else if (statuscurtain == "กำลังทำงาน") {
      statuscurtainColor = Colors.orange;
    }

    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheel = appProvider.lux.toDouble();
    if (wheel >= 0 && wheel <= 100) {
      wheel = wheel / 100;
    } else if (wheel > 100 && wheel <= 1000) {
      wheel = wheel / 1000;
    } else if (wheel > 1000 && wheel <= 10000) {
      wheel = wheel / 10000;
    } else if (wheel > 10000) {
      wheel = wheel / 100000;
    }

    //ขนาด TextField
    double screenWidth;
    screenWidth = MediaQuery.of(context).size.width;

    TextEditingController? setHour;

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
                    "การให้แสง",
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
                            textTitel: "${appProvider.lux}",
                            textLong: "Lux"),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Light intensity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: toneColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ความสมดุล: ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: toneColor,
                              ),
                            ),
                            Text(
                              message,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "สถานะม่านบังแสง: ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: toneColor,
                              ),
                            ),
                            Text(
                              statuscurtain,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: statuscurtainColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "บันทึกการเก็บแสง: ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: toneColor,
                              ),
                            ),
                            Text(
                              "${appProvider.record}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: toneColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'การทำงาน',
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'ควบคุมม่าน',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Tooltip(
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
                                  children: [
                                    Text(
                                      'อัตโนมัติ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: toneColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Tooltip(
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /* ElevatedButton(
                                          onPressed: () {
                                            if (appProvider.lightAuto ==
                                                false) {
                                              setState(() {});
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/fullDay')
                                                  .set(0);
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/halfDay')
                                                  .set(1);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: appProvider.halfDay
                                                ? toneColor
                                                : Colors.grey,
                                          ),
                                          child: const Text('ครึ่งวัน'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (appProvider.lightAuto ==
                                                false) {
                                              setState(() {});
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/halfDay')
                                                  .set(0);
                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/MOTOR/setAuto/fullDay')
                                                  .set(1);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: appProvider.fullDay
                                                ? toneColor
                                                : Colors.grey,
                                          ),
                                          child: const Text('เต็มวัน'),
                                        ), */
                                        SizedBox(
                                          width: 80,
                                          height: 40,
                                          child: Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: setHour,
                                              maxLength: 2,
                                              keyboardType:
                                                  TextInputType.number,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                              decoration: const InputDecoration(
                                                labelText: 'ชั่วโมง',
                                                counterText: '',
                                                labelStyle:
                                                    TextStyle(fontSize: 15),
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: FlutterSwitch(
                                            width: 100,
                                            height: 42,
                                            activeText: 'เปิด',
                                            inactiveText: 'ปิด',
                                            valueFontSize: 20,
                                            toggleSize: 25.0,
                                            value: appProvider.lightAuto,
                                            borderRadius: 30.0,
                                            padding: 8.0,
                                            showOnOff: true,
                                            activeColor: toneColor,
                                            onToggle: (value) {
                                              setState(() {
                                                _statusAuto = value;
                                              });
                                              TextEditingController? setHour0 =
                                                  setHour;

                                              int statusAuto =
                                                  _statusAuto ? 1 : 0;

                                              databaseReference
                                                  .child(
                                                      'ESP32/setControl/setAutoMode/motor')
                                                  .set(statusAuto);

                                              if (statusAuto == 1) {
                                                databaseReference
                                                    .child(
                                                        'ESP32/setControl/MOTOR/setAuto/hour')
                                                    .set(setHour0);
                                              }
                                            },
                                          ),
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
                                  children: [
                                    Text(
                                      'ตั้งเวลา',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: toneColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Tooltip(
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
                                  height: 42,
                                  activeText: 'เปิด',
                                  inactiveText: 'ปิด',
                                  valueFontSize: 20,
                                  toggleSize: 25.0,
                                  value: appProvider.setTimeLight,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  activeColor: toneColor,
                                  onToggle: (value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                    int setTime = isSwitched ? 1 : 0;

                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setTimerMode/motor')
                                        .set(setTime);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setAutoMode/motor')
                                        .set(0);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'ตั้งเวลา',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
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
                                children: [
                                  Text(
                                    'ตั้งเวลาเปิด',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
                                  ),
                                  Text(
                                    'ตั้งเวลาปิด',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: toneColor,
                                    ),
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
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'เวลา : ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: toneColor,
                                            ),
                                          ),
                                          Text(
                                            '${timestart.hour} : ${timestart.minute}',
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
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'เวลา : ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: toneColor,
                                            ),
                                          ),
                                          Text(
                                            '${timestop.hour} : ${timestop.minute}',
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
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: elevatedButton(
                                    text: "ยืนยัน",
                                    colors: [
                                      Colors.grey.shade700,
                                      Colors.grey.shade700,
                                      Colors.grey.shade700,
                                    ],
                                    onPressed: () {
                                      int hour = timestart.hour;
                                      int minute = timestart.minute;

                                      String setTimeStart = '$hour:$minute';

                                      databaseReference
                                          .child(
                                              'ESP32/setControl/MOTOR/setTimeStart')
                                          .set(setTimeStart);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: elevatedButton(
                                    text: "ยืนยัน",
                                    colors: [
                                      Colors.grey.shade700,
                                      Colors.grey.shade700,
                                      Colors.grey.shade700,
                                    ],
                                    onPressed: () {
                                      int hour = timestop.hour;
                                      int minute = timestop.minute;

                                      String setTimeStop = '$hour:$minute';

                                      databaseReference
                                          .child(
                                              'ESP32/setControl/MOTOR/setTimeStop')
                                          .set(setTimeStop);
                                    },
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
      backgroundColor: Colors.grey.shade400,
      circularStrokeCap: CircularStrokeCap.round,
      rotateLinearGradient: true,
      maskFilter: const MaskFilter.blur(BlurStyle.solid, 8.0),
      linearGradient: LinearGradient(
        colors: [
          Colors.grey.shade700,
          Colors.grey.shade700,
          Colors.grey.shade700,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textTitel,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: toneColor,
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
      ..color = isPressed ? Colors.grey.shade800 : Colors.grey
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
