import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rmuti_iot/models/sensor.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final StreamController<Esp32> _streamController = StreamController();
  final databaseReference = FirebaseDatabase.instance.ref();

  bool _statusAuto = false;
  bool isSwitched = false;

  // set time start
  DateTime datestart = DateTime(21, 1, 1);
  DateTime timestart = DateTime(11, 22);
  // set time stop
  DateTime datestop = DateTime(22, 8, 3);
  DateTime timestop = DateTime(15, 55);

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  void initState() {
    super.initState();
    _loadSwitchState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      getData();
    });

    // Listen for changes to the Firebase database
    databaseReference.child('ESP32/setControl/setAutoMode/npk').onValue.listen((event) {
      int statusAuto = (event.snapshot.value as int);
      setState(() {
        _statusAuto = (statusAuto == 1);
      });
    });
    // Listen for changes to the Firebase database
    databaseReference.child('ESP32/setControl/setTimerMode/pump').onValue.listen((event) {
      int settime = (event.snapshot.value as int);
      setState(() {
        isSwitched = (settime == 1);
      });
    });
  }

  Future<void> getData() async {
    var url = Uri.parse(
        'https://projectgreenhouse-6f492-default-rtdb.asia-southeast1.firebasedatabase.app/ESP32.json');

    final response = await http.get(url);
    final databody = json.decode(response.body);

    Esp32 esp32 = Esp32.fromJson(databody);

    if (!_streamController.isClosed) _streamController.sink.add(esp32);
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _statusAuto = prefs.getBool('_statusAuto') ?? false;
      isSwitched = prefs.getBool('isSwitched') ?? false;
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
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

//ฟังก์ชันความสมดุลแสดง Text ตามค่าที N
  String displayTextN(Esp32 esp32) {
    String textToDisplay = '';
    if (esp32.rs485.n <= 9) {
      textToDisplay = "ต่ำมาก";
    } else if (esp32.rs485.n >= 10 && esp32.rs485.n <= 100) {
      textToDisplay = "ต่ำ";
    } else if (esp32.rs485.n >= 110 && esp32.rs485.n <= 200) {
      textToDisplay = "ปานกลาง";
    } else if (esp32.rs485.n >= 210 && esp32.rs485.n <= 300) {
      textToDisplay = "สูง";
    } else if (esp32.rs485.n >= 310 && esp32.rs485.n <= 500) {
      textToDisplay = "สูงมาก";
    }
    return textToDisplay;
  }

  //ฟังก์ชันความสมดุลแสดง Text ตามค่าที P
  String displayTextP(Esp32 esp32) {
    String textToDisplay = '';
    if (esp32.rs485.n <= 9) {
      textToDisplay = "ต่ำมาก";
    } else if (esp32.rs485.n >= 10 && esp32.rs485.n <= 39) {
      textToDisplay = "ต่ำ";
    } else if (esp32.rs485.n >= 40 && esp32.rs485.n <= 69) {
      textToDisplay = "ปานกลาง";
    } else if (esp32.rs485.n >= 70 && esp32.rs485.n <= 99) {
      textToDisplay = "สูง";
    } else if (esp32.rs485.n >= 100 && esp32.rs485.n <= 120) {
      textToDisplay = "สูงมาก";
    }
    return textToDisplay;
  }

  //ฟังก์ชันความสมดุลแสดง Text ตามค่าที K
  String displayTextK(Esp32 esp32) {
    String textToDisplay = '';
    if (esp32.rs485.n <= 39) {
      textToDisplay = "ต่ำ";
    } else if (esp32.rs485.n >= 40 && esp32.rs485.n <= 79) {
      textToDisplay = "ปานกลาง";
    } else if (esp32.rs485.n >= 80 && esp32.rs485.n <= 120) {
      textToDisplay = "สูง";
    }
    return textToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<Esp32>(
          stream: _streamController.stream,
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return Stack(
                  children: [
                    const Image(
                      image: AssetImage('images/greenhouse.png'),
                      width: 200,
                      height: 200,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 200,
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.5),
                        child: const Text(
                          'รอสักครู่...',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              default:
                if (snapdata.hasError) {
                  return const Text('Please Wait....');
                } else {
                  return BuildFertilizer(snapdata.data!);
                }
            }
          },
        ),
      ),
    );
  }

  Widget BuildFertilizer(Esp32 esp32) {
    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheelN = esp32.rs485.n.toDouble();
    double wheelP = esp32.rs485.p.toDouble();
    double wheelK = esp32.rs485.k.toDouble();
    if (wheelN >= 1 && wheelN <= 100) {
      wheelN = wheelN / 100;
    } else if (wheelN > 100) {
      wheelN = 100;
      wheelN = wheelN / 100;
    }
    if (wheelP >= 1 && wheelP <= 100) {
      wheelP = wheelP / 100;
    } else if (wheelP > 100) {
      wheelP = 100;
      wheelP = wheelP / 100;
    }
    if (wheelK >= 1 && wheelK <= 100) {
      wheelK = wheelK / 100;
    } else if (wheelK > 100) {
      wheelK = 100;
      wheelK = wheelK / 100;
    }

    //ขนาด TextField
    double screenWidth;
    screenWidth = MediaQuery.of(context).size.width;

    // เปลี่ยนสีข้อความสีส่งมาจากฟังก์ชัน displayText(esp32)   N
    String message = displayTextN(esp32);
    Color textColor = Colors.black;
    if (message == "ต่ำมาก") {
      textColor = Colors.red;
    } else if (message == "ต่ำ") {
      textColor = Colors.orange;
    } else if (message == "ปานกลาง") {
      textColor = Colors.green;
    } else if (message == "สูง") {
      textColor = Colors.orange;
    } else if (message == "สูงมาก") {
      textColor = Colors.red;
    }

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
                    "แสดงค่าปุ๋ย",
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
                      esp32.rtc1307.time,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 60,
                              lineWidth: 14,
                              percent: wheelN,
                              progressColor: Colors.indigo,
                              center: RichText(
                                text: TextSpan(
                                  text: " ${esp32.rs485.n}\n",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: "mg/kg",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                              "ค่า N",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 40,
                          height: 180,
                        ),
                        Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 60,
                              lineWidth: 14,
                              percent: wheelP,
                              progressColor: Colors.indigo,
                              center: RichText(
                                text: TextSpan(
                                  text: " ${esp32.rs485.p}\n",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: "mg/kg",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                              "ค่า P",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 60,
                          lineWidth: 14,
                          percent: wheelK,
                          progressColor: Colors.indigo,
                          center: Padding(
                            padding: const EdgeInsets.all(22),
                            child: RichText(
                                text: TextSpan(
                                  text: " ${esp32.rs485.k}\n",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: "mg/kg",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ),
                        ),
                        const Text(
                          "ค่า K",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Auto Fertilizer',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Tooltip(
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
                                  height: 40,
                                  valueFontSize: 25,
                                  toggleSize: 45.0,
                                  value: _statusAuto,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  onToggle: (value) {
                                    setState(() {
                                      _statusAuto = value;
                                      _saveSwitchState('_statusAuto', value);
                                    });
                                    int statusAuto = _statusAuto ? 1 : 0;
                                    // ส่งค่ากลับไป Firebase เพื่อสั่งรดน้ำ
                                    databaseReference
                                        .child('ESP32/setControl/setAutoMode/npk')
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
                                            'ESP32/setControl/setTimerMode/npk')
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
                                              'ESP32/setControl/PUMP/setTimeStart/hour')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/PUMP/setTimeStart/minute')
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
                                              'ESP32/setControl/PUMP/setTimeStop/hour')
                                          .set(hour);
                                      databaseReference
                                          .child(
                                              'ESP32/setControl/PUMP/setTimeStop/minute')
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
