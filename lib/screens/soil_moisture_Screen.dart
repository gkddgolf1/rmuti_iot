// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../buttons/buttons.dart';
import '../services/app_provider.dart';

class SoilMoistureScreen extends StatefulWidget {
  const SoilMoistureScreen({super.key});

  @override
  State<SoilMoistureScreen> createState() => _SoilMoistureScreenState();
}

class _SoilMoistureScreenState extends State<SoilMoistureScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Color toneColor = Colors.grey.shade800;

  final double horizontalPadding = 15;
  final double verticalPadding = 15;

  // ค่าของ Slid
  List<int> allowedValues = [20, 40, 60, 80, 100];
  List<int> allowedValuesSet = [20, 40, 60, 80, 100];

  // ตัวแปรสำหรับ Switch
  bool _status = false;
  bool _statusAuto = false;
  bool isSwitched = false;

  // set time start
  DateTime timestart = DateTime(11, 22);
  // set time stop
  DateTime timestop = DateTime(15, 55);

  @override
  void initState() {
    super.initState();
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
    final appProvider = Provider.of<AppProvider>(context);
    String textToDisplay = '';
    if (appProvider.soilMoisture <= 39) {
      textToDisplay = "สภาวะวิกฤติ";
    } else if (appProvider.soilMoisture >= 40 &&
        appProvider.soilMoisture <= 49) {
      textToDisplay = "สภาวะดินแห้ง";
    } else if (appProvider.soilMoisture >= 50 &&
        appProvider.soilMoisture <= 69) {
      textToDisplay = "สภาวะดินปกติ";
    } else if (appProvider.soilMoisture >= 70 &&
        appProvider.soilMoisture <= 79) {
      textToDisplay = "สภาวะดินแฉะ";
    } else if (appProvider.soilMoisture >= 80 &&
        appProvider.soilMoisture <= 100) {
      textToDisplay = "สภาวะอันตรายต่อพืช";
    }

    return textToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    // เปลี่ยนสีข้อความสีส่งมาจากฟังก์ชัน displayText()
    String message = displayText();
    Color textColor = Colors.black;
    if (message == "สภาวะวิกฤติ") {
      textColor = Colors.red;
    } else if (message == "สภาวะดินแห้ง") {
      textColor = Colors.orange;
    } else if (message == "สภาวะดินปกติ") {
      textColor = Colors.green;
    } else if (message == "สภาวะดินแฉะ") {
      textColor = Colors.orange;
    } else if (message == "สภาวะอันตรายต่อพืช") {
      textColor = Colors.red;
    }

    // เปลี่ยนสี slide แรงดันน้ำ
    Color rangeColor = Colors.black;
    if (appProvider.speedPump >= 0 && appProvider.speedPump <= 80) {
      rangeColor = Colors.grey.shade700;
    } else {
      rangeColor = Colors.red;
    }

    // เปลี่ยนสี slide ความชื้น
    Color soilColor = Colors.black;
    if (appProvider.setSoilmoisture >= 0 && appProvider.setSoilmoisture <= 80) {
      soilColor = Colors.grey.shade700;
    } else {
      soilColor = Colors.red;
    }

    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheel = appProvider.soilMoisture.toDouble();
    if (wheel >= 1 && wheel <= 100) {
      wheel = wheel / 100;
    } else if (wheel > 100) {
      wheel = 100;
      wheel = wheel / 100;
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
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: toneColor,
                    ),
                  ),
                  Text(
                    "ความชื้นดิน",
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
                        Container(
                          child: _wheelCircle(
                            percentWheel: wheel,
                            textTitel: "${appProvider.soilMoisture}%",
                            //textLong: "Soil Moisture",
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Soil Moisture",
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
                      ],
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'การตั้งค่า',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'แรงดันน้ำ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Tooltip(
                                  message: 'ปรับแรงดันของปั้มน้ำ',
                                  triggerMode:
                                      TooltipTriggerMode.tap, // tooltip text
                                  child: Icon(Icons.help_outline),
                                ),
                              ],
                            ),
                          ),
                          SfSliderTheme(
                            data: SfSliderThemeData(
                              tooltipBackgroundColor: Colors.blue,
                              overlayColor: Colors.transparent,
                              activeTrackColor: rangeColor,
                              thumbColor: rangeColor,
                              inactiveTrackColor: Colors.grey.shade500,
                            ),
                            child: SfSlider(
                              //enableTooltip: true,
                              numberFormat: NumberFormat('#'),
                              showLabels: true,
                              showTicks: true,
                              interval: 20,
                              min: 20,
                              max: 100,
                              value: appProvider.speedPump,
                              onChanged: (dynamic value) {
                                int roundedValue = value.round();
                                int nearestAllowedValue = allowedValues.reduce(
                                  (a, b) => (roundedValue - a).abs() <
                                          (roundedValue - b).abs()
                                      ? a
                                      : b,
                                );
                                /* setState(() {
                                  appProvider.speedPump = nearestAllowedValue;
                                }); */
                                int speedpump = nearestAllowedValue;
                                databaseReference
                                    .child('ESP32/setControl/PUMP/speedPump')
                                    .set(speedpump);
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'ความชื้น',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Tooltip(
                                  message: 'ตั้งค่าความชื้นที่เหมาะสมกับต้นไม้',
                                  triggerMode:
                                      TooltipTriggerMode.tap, // tooltip text
                                  child: Icon(Icons.help_outline),
                                ),
                              ],
                            ),
                          ),
                          SfSliderTheme(
                            data: SfSliderThemeData(
                              tooltipBackgroundColor: Colors.blue,
                              overlayColor: Colors.transparent,
                              activeTrackColor: soilColor,
                              thumbColor: soilColor,
                              inactiveTrackColor: Colors.grey.shade500,
                            ),
                            child: SfSlider(
                              //enableTooltip: true,
                              numberFormat: NumberFormat('#'),
                              showLabels: true,
                              showTicks: true,
                              interval: 20,
                              min: 20,
                              max: 100,
                              value: appProvider.setSoilmoisture.toDouble(),
                              onChanged: (dynamic value) {
                                int roundedValue = value.round();
                                int nearestAllowedValueSet =
                                    allowedValuesSet.reduce(
                                  (a, b) => (roundedValue - a).abs() <
                                          (roundedValue - b).abs()
                                      ? a
                                      : b,
                                );

                                int setsoilmoisture = nearestAllowedValueSet;
                                databaseReference
                                    .child(
                                        'ESP32/setControl/PUMP/setSoilmoilsture')
                                    .set(setsoilmoisture);
                              },
                            ),
                          ),
                        ],
                      ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Text(
                                      'รดน้ำ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: toneColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Tooltip(
                                      message: 'เปิด-ปิดน้ำ',
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
                                  value: appProvider.status,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  activeColor: toneColor,
                                  onToggle: (value) {
                                    setState(() {
                                      _status = value;
                                    });
                                    int sentStatus = _status ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ
                                    databaseReference
                                        .child('ESP32/setControl/PUMP/status')
                                        .set(sentStatus);
                                  },
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
                                      'อัตโนมัติ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: toneColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Tooltip(
                                      message:
                                          'จะรดน้ำเมื่อความชื้นต่ำกว่ากำหนด',
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
                                  value: appProvider.statusAuto,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  activeColor: toneColor,
                                  onToggle: (value) async {
                                    setState(() {
                                      _statusAuto = value;
                                    });
                                    int sentStatusAuto = _statusAuto ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setAutoMode/pump')
                                        .set(sentStatusAuto);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setTimerMode/pump')
                                        .set(0);
                                  },
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
                                      message: 'ตั้งเวลารดน้ำ',
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
                                  value: appProvider.isSwitched,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  activeColor: toneColor,
                                  onToggle: (value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                    int setTime = isSwitched ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setTimerMode/pump')
                                        .set(setTime);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setAutoMode/pump')
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
                                              'ESP32/setControl/PUMP/setTimeStart')
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
                                              'ESP32/setControl/PUMP/setTimeStop')
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
                    const SizedBox(height: 24),
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
    //required String textLong,
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
          /* Text(
            textLong,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ), */
        ],
      ),
    );
  }
}
