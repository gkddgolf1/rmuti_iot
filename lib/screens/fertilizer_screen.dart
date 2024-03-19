import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:rmuti_iot/buttons/buttons.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../services/app_provider.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Color toneColor = Colors.grey.shade800;

  // สวิท
  bool _statusAuto = false;
  bool isSwitched = false;

  // set time start
  DateTime timestart = DateTime(11, 22);
  // set time stop
  DateTime timestop = DateTime(15, 55);

  // ค่าของ Slid
  List<int> allowedValues = [1, 2, 3];

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

//ฟังก์ชันความสมดุลค่าปุ๋ย
  String displayText() {
    final appProvider = Provider.of<AppProvider>(context);
    String textToDisplay = '';
    if (appProvider.fertilizer == 0) {
      textToDisplay = "ขาดปุ๋ย";
    } else if (appProvider.fertilizer == 1) {
      textToDisplay = "ปุ๋ยน้อย";
    } else if (appProvider.fertilizer == 2) {
      textToDisplay = "อุดมสมบูรณ์";
    } else if (appProvider.fertilizer == 3) {
      textToDisplay = "อุดมสมบูรณ์มาก";
    }
    return textToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    String messageFertilizer = displayText();

    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheelFertilizer = appProvider.fertilizer.toDouble();
    if (wheelFertilizer == 0) {
      wheelFertilizer = wheelFertilizer / 100;
    } else if (wheelFertilizer == 1) {
      wheelFertilizer = 33.34;
      wheelFertilizer = wheelFertilizer / 100;
    } else if (wheelFertilizer == 2) {
      wheelFertilizer = 66.68;
      wheelFertilizer = wheelFertilizer / 100;
    } else if (wheelFertilizer == 3) {
      wheelFertilizer = 100;
      wheelFertilizer = wheelFertilizer / 100;
    }

    //ขนาด TextField ของตั้งเวลา
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
                  const Text(
                    "การให้ปุ๋ย",
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
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        _wheelCircle(
                          percentWheel: wheelFertilizer,
                          textTitel: messageFertilizer,
                          //textLong: "ความอุดมสมบูรณ์",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Fertilizer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'การให้ปุ๋ย',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: toneColor,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Tooltip(
                                  message: 'ปรับระดับการให้ปุ๋ย',
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
                              activeTrackColor: Colors.grey.shade700,
                              thumbColor: Colors.grey.shade700,
                              inactiveTrackColor: Colors.grey.shade500,
                            ),
                            child: SfSlider(
                              numberFormat: NumberFormat('#'),
                              showLabels: true,
                              showTicks: true,
                              interval: 1,
                              min: 1,
                              max: 3,
                              value: appProvider.setNPK.toDouble(),
                              labelFormatterCallback:
                                  (dynamic value, String formattedText) {
                                switch (value) {
                                  case 1:
                                    return 'น้อย';
                                  case 2:
                                    return 'ปานกลาง';
                                  case 3:
                                    return 'มาก';
                                }
                                return formattedText;
                              },
                              onChanged: (dynamic value) {
                                // เมื่อค่าเปลี่ยนแปลง ทำการปัดค่าทศนิยมเป็นจำนวนเต็ม
                                int roundedValue = value.round();

                                // หาค่าใน allowedValues ที่ใกล้ที่สุดกับ roundedValue
                                int nearestAllowedValue = allowedValues.reduce(
                                  (a, b) => (roundedValue - a).abs() <
                                          (roundedValue - b).abs()
                                      ? a
                                      : b,
                                );

                                // นำค่าที่หาได้มาเก็บไว้ในตัวแปร test
                                int test = nearestAllowedValue;

                                // เขียนค่า test ลงใน Firebase Realtime Database
                                databaseReference
                                    .child('ESP32/setControl/NPK/test')
                                    .set(test);

                                // ตรวจสอบค่าใน nearestAllowedValue แล้วกำหนดค่าใน Firebase Realtime Database ตามเงื่อนไข
                                if (nearestAllowedValue == 1) {
                                  databaseReference
                                      .child('ESP32/setControl/NPK/NPK')
                                      .set("Low");
                                } else if (nearestAllowedValue == 2) {
                                  databaseReference
                                      .child('ESP32/setControl/NPK/NPK')
                                      .set("Normal");
                                } else if (nearestAllowedValue == 3) {
                                  databaseReference
                                      .child('ESP32/setControl/NPK/NPK')
                                      .set("High");
                                }
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
                          color: toneColor,
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
                                      'อัตโนมัติ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: toneColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Tooltip(
                                      message: 'ให้ปุ๋ยเมื่อขาดสารอาหาร',
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
                                  value: appProvider.fertilizerAuto,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  activeColor: toneColor,
                                  onToggle: (value) {
                                    setState(() {
                                      _statusAuto = value;
                                    });
                                    int statusAuto = _statusAuto ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setAutoMode/npk')
                                        .set(statusAuto);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setTimerMode/npk')
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: toneColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Tooltip(
                                      message: 'ตั้งเวลาให้ปุ๋ย',
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
                                  value: appProvider.setTimeFertilizer,
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
                                            'ESP32/setControl/setTimerMode/npk')
                                        .set(setTime);
                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setAutoMode/npk')
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
                          color: toneColor,
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
                                    'ตั้งเวลาให้ปุ๋ย',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: toneColor,
                                    ),
                                  ),
                                  /* Text(
                                    'Set Time Off',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ), */
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
                                          Text(
                                            'เวลา : ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: toneColor,
                                            ),
                                          ),
                                          Text(
                                            '${timestart.hour} : ${timestart.minute}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: toneColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /* Padding(
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
                                ), */
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      int hour = timestart.hour;
                                      int minute = timestart.minute;

                                      String setTimeStart = '$hour:$minute';

                                      databaseReference
                                          .child(
                                              'ESP32/setControl/NPK/setTimeStart')
                                          .set(setTimeStart);
                                    },
                                  ),
                                ),
                                /* Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: elevatedButton(
                                    text: "Set Stop",
                                    colors: [
                                      const Color.fromARGB(255, 24, 116, 24),
                                      const Color.fromARGB(255, 26, 160, 26),
                                      const Color.fromARGB(255, 24, 156, 24),
                                    ],
                                    onPressed: () {
                                      int hour = timestop.hour;
                                      int minute = timestop.minute;

                                      databaseReference
                                          .child(
                                              'ESP32/setControl/NPK/setTimeStop/hour')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/NPK/setTimeStop/minute')
                                          .set(minute);
                                    },
                                  ),
                                ), */
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
      backgroundColor: Colors.deepPurple.shade100,
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
              fontSize: 22,
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
