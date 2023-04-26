import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:percent_indicator/percent_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SoilMoistureScreen extends StatefulWidget {
  const SoilMoistureScreen({super.key});

  @override
  State<SoilMoistureScreen> createState() => _SoilMoistureScreenState();
}

class _SoilMoistureScreenState extends State<SoilMoistureScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  var soilMoisture = 0;
  var _time = '';
  var speedPump = 0;
  var setSoilmoisture = 0;

  double _speedPump = 0;
  double _setSoilmoisture = 0;

  bool _status = false;
  bool _statusAuto = false;
  bool isSwitched = false;

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

    // Listen for changes to the Firebase database
    databaseReference
        .child('ESP32/setControl/PUMP/status')
        .onValue
        .listen((event) {
      int status = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _status = (status == 1);
        });
      }
    });
    databaseReference
        .child('ESP32/setControl/setAutoMode/pump')
        .onValue
        .listen((event) {
      int statusAuto = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _statusAuto = (statusAuto == 1);
        });
      }
    });
    // Listen for changes to the Firebase database
    databaseReference
        .child('ESP32/setControl/setTimerMode/pump')
        .onValue
        .listen((event) {
      int settime = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          isSwitched = (settime == 1);
        });
      }
    });
    // BH1750
    databaseReference.child('ESP32/TrTs/soil_moisture').onValue.listen((event) {
      int soilmoisture = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          soilMoisture = soilmoisture;
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
    // speedPump
    databaseReference
        .child('ESP32/setControl/PUMP/speedPump')
        .onValue
        .listen((event) {
      int speedpump = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          speedPump = speedpump;
        });
      }
    });
    // setSoilmoisture
    databaseReference
        .child('ESP32/setControl/PUMP/setSoilmoilsture')
        .onValue
        .listen((event) {
      int setsoilmoisture = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          setSoilmoisture = setsoilmoisture;
        });
      }
    });
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = prefs.getBool('_status') ?? false;
      _statusAuto = prefs.getBool('_statusAuto') ?? false;
      isSwitched = prefs.getBool('isSwitched') ?? false;
      _speedPump = prefs.getDouble('_speedPump') ?? 0.0;
      _setSoilmoisture = prefs.getDouble('_setSoilmoisture') ?? 0.0;
    });
  }

  void _saveSwitchState(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
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
    if (soilMoisture <= 39) {
      textToDisplay = "สภาวะวิกฤติ";
    } else if (soilMoisture >= 40 && soilMoisture <= 49) {
      textToDisplay = "สภาวะดินแห้ง";
    } else if (soilMoisture >= 50 && soilMoisture <= 69) {
      textToDisplay = "สภาวะดินปกติ";
    } else if (soilMoisture >= 70 && soilMoisture <= 79) {
      textToDisplay = "สภาวะดินแฉะ";
    } else if (soilMoisture >= 80 && soilMoisture <= 100) {
      textToDisplay = "สภาวะอันตรายต่อพืช";
    }

    return textToDisplay;
  }

  @override
  Widget build(BuildContext context) {
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
    if (speedPump >= 0 && speedPump <= 80) {
      rangeColor = Colors.green;
    } else {
      rangeColor = Colors.red;
    }

    // เปลี่ยนสี slide ความชื้น
    Color soilColor = Colors.black;
    if (setSoilmoisture >= 0 && setSoilmoisture <= 80) {
      soilColor = Colors.green;
    } else {
      soilColor = Colors.red;
    }

    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheel = soilMoisture.toDouble();
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
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.indigo,
                    ),
                  ),
                  const Text(
                    "Soil Moisture",
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
                      _time,
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
                        CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 20,
                          percent: wheel,
                          progressColor: Colors.deepPurple,
                          backgroundColor: Colors.deepPurple.shade100,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "$soilMoisture%",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Soil Moisture",
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "แรงดันน้ำปัจจุบัน: ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$speedPump',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "ระดับความชื้นปกติ: ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$setSoilmoisture',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: const [
                                Text(
                                  'แรงดันน้ำ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Tooltip(
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
                              inactiveTrackColor: rangeColor,
                            ),
                            child: SfSlider(
                              //enableTooltip: true,
                              numberFormat: NumberFormat('#'),
                              showLabels: true,
                              interval: 20,
                              min: 0,
                              max: 100,
                              value: _speedPump,
                              onChanged: (value) {
                                setState(() {
                                  _speedPump = value;
                                  _saveSwitchState('_speedPump', value);
                                });
                                int speedPump = _speedPump.truncate();
                                databaseReference
                                    .child('ESP32/setControl/PUMP/speedPump')
                                    .set(speedPump);
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: const [
                                Text(
                                  'ความชื้น',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Tooltip(
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
                              inactiveTrackColor: soilColor,
                            ),
                            child: SfSlider(
                              //enableTooltip: true,
                              numberFormat: NumberFormat('#'),
                              showLabels: true,
                              interval: 20,
                              min: 0,
                              max: 100,
                              value: _setSoilmoisture,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _setSoilmoisture = value;
                                  _saveSwitchState('_setSoilmoisture', value);
                                });
                                int setsoilmoisture =
                                    _setSoilmoisture.truncate();
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Sprinkle',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Tooltip(
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
                                  height: 40,
                                  valueFontSize: 25,
                                  toggleSize: 45.0,
                                  value: _status,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  onToggle: (value) {
                                    setState(() {
                                      _status = value;
                                      _saveSwitchState('_status', value);
                                    });
                                    int status = _status ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ
                                    databaseReference
                                        .child('ESP32/setControl/PUMP/status')
                                        .set(status);
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
                                  children: const [
                                    Text(
                                      'Auto Sprinkle',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Tooltip(
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
                                  height: 40,
                                  valueFontSize: 25,
                                  toggleSize: 45.0,
                                  value: _statusAuto,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  onToggle: (value) async {
                                    setState(() {
                                      _statusAuto = value;
                                      _saveSwitchState('_statusAuto', value);
                                    });
                                    int statusAuto = _statusAuto ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ

                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setAutoMode/pump')
                                        .set(statusAuto);
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
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ

                                    databaseReference
                                        .child(
                                            'ESP32/setControl/setTimerMode/pump')
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
                                              'ESP32/setControl/PUMP/setTimeStart')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/PUMP/setTimeStart')
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
                                              'ESP32/setControl/PUMP/setTimeStop')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/PUMP/setTimeStop')
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
        ),
      ),
    );
  }
}
