import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:rmuti_iot/buttons/buttons.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  // รับมาแสดง
  var N = 0;
  var P = 0;
  var K = 0;
  var _time = '';
  var setN = 0;
  var setP = 0;
  var setK = 0;

  // นำไป set
  TextEditingController valueN = TextEditingController();
  TextEditingController valueP = TextEditingController();
  TextEditingController valueK = TextEditingController();

  // สวิท
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
    //_loadSwitchState();

    // ----------------------- setControl -------------------------- //
    // setAutoMode
    databaseReference
        .child('ESP32/setControl/setAutoMode/npk')
        .onValue
        .listen((event) {
      int statusAuto = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          _statusAuto = (statusAuto == 1);
        });
      }
    });
    // setTimerMode
    databaseReference
        .child('ESP32/setControl/setTimerMode/npk')
        .onValue
        .listen((event) {
      int settime = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          isSwitched = (settime == 1);
        });
      }
    });
    // setN
    databaseReference.child('ESP32/setControl/NPK/N').onValue.listen((event) {
      int n = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          setN = n;
        });
      }
    });
    // setP
    databaseReference.child('ESP32/setControl/NPK/P').onValue.listen((event) {
      int p = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          setP = p;
        });
      }
    });
    //  setK
    databaseReference.child('ESP32/setControl/NPK/K').onValue.listen((event) {
      int k = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          setK = k;
        });
      }
    });

    // ---------------------------- views ------------------------ //
    // RTC1307
    databaseReference.child('ESP32/views/RTC1307/Time').onValue.listen((event) {
      var time = event.snapshot.value;
      if (mounted) {
        setState(() {
          _time = time.toString();
        });
      }
    });
    // RS485 == N
    databaseReference.child('ESP32/views/RS485/N').onValue.listen((event) {
      int n = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          N = n;
        });
      }
    });
    // RS485 == P
    databaseReference.child('ESP32/views/RS485/P').onValue.listen((event) {
      int p = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          P = p;
        });
      }
    });
    // RS485 == K
    databaseReference.child('ESP32/views/RS485/K').onValue.listen((event) {
      int k = (event.snapshot.value as int);
      if (mounted) {
        setState(() {
          K = k;
        });
      }
    });
  }

  /* void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _statusAuto = prefs.getBool('_statusAuto') ?? false;
      isSwitched = prefs.getBool('isSwitched') ?? false;
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  } */

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
  String displayTextN() {
    String textToDisplay = '';
    if (N < 90 && P < 10 && K < 100) {
      textToDisplay = "ขาดปุ๋ย";
    } else if (N >= 90 && N < 120 && P >= 10 && P < 20 && K >= 100 && K < 150) {
      textToDisplay = "ปุ๋ยน้อย";
    } else if (N >= 120 &&
        N < 150 &&
        P >= 20 &&
        P < 40 &&
        K >= 150 &&
        K < 200) {
      textToDisplay = "ปานกลาง";
    } else if (N >= 150 &&
        N < 200 &&
        P >= 40 &&
        P < 80 &&
        K >= 200 &&
        K < 250) {
      textToDisplay = "อุดมสมบูรณ์";
    }
    return textToDisplay;
  }

  /* //ฟังก์ชันความสมดุลแสดง Text ตามค่าที P
  String displayTextP() {
    String textToDisplay = '';
    if (P < 10) {
      textToDisplay = "ขาดปุ๋ย";
    } else if (P >= 10 && P < 20) {
      textToDisplay = "ปุ๋ยน้อย";
    } else if (P >= 20 && P < 40) {
      textToDisplay = "ปานกลาง";
    } else if (P >= 40 && P < 80) {
      textToDisplay = "อุดมสมบูรณ์";
    }
    return textToDisplay;
  }

  //ฟังก์ชันความสมดุลแสดง Text ตามค่าที K
  String displayTextK() {
    String textToDisplay = '';
    if (K < 100) {
      textToDisplay = "ขาดปุ๋ย";
    } else if (K >= 100 && K < 150) {
      textToDisplay = "ปุ๋ยน้อย";
    } else if (K >= 150 && K < 200) {
      textToDisplay = "ปานกลาง";
    } else if (K >= 200 && K < 250) {
      textToDisplay = "อุดมสมบูรณ์";
    }
    return textToDisplay;
  } */

  @override
  Widget build(BuildContext context) {
    // ประกาศตัวแปร wheel ขึ้นมาเพื่อเก็บไปเป็นค่าวงล้อ
    double wheelN = N.toDouble();
    double wheelP = P.toDouble();
    double wheelK = K.toDouble();
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
    String message = displayTextN();
    Color textColor = Colors.black;
    if (message == "ขาดปุ๋ย") {
      textColor = Colors.red;
    } else if (message == "ปุ๋ยน้อย") {
      textColor = Colors.orange;
    } else if (message == "ปานกลาง") {
      textColor = Colors.green;
    } else if (message == "อุดมสมบูรณ์") {
      textColor = Colors.orange;
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
                      color: Color.fromARGB(255, 24, 116, 24),
                    ),
                  ),
                  const Text(
                    "Fertilizer",
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
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            _wheelCircle(
                                percentWheel: wheelN,
                                textTitel: "$N",
                                textLong: "mg/kg"),
                            const SizedBox(
                              height: 20,
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
                          width: 10,
                          height: 180,
                        ),
                        Column(
                          children: [
                            _wheelCircle(
                                percentWheel: wheelP,
                                textTitel: "$P",
                                textLong: "mg/kg"),
                            const SizedBox(
                              height: 20,
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
                        _wheelCircle(
                            percentWheel: wheelN,
                            textTitel: "$K",
                            textLong: "mg/kg"),
                        const SizedBox(
                          height: 20,
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
                              "ความอุดมสมบูรณ์: ",
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
                              "ตั้งค่าให้ปุ๋ย: ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'N: $setN ',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'P: $setP ',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'K: $setK ',
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
                        roundedButton(
                            title: 'Control',
                            color: const Color.fromARGB(255, 24, 116, 24)),
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Text(
                                      'ตั้งค่าปุ๋ย',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Tooltip(
                                      message: 'ใส่ค่า NPK',
                                      triggerMode: TooltipTriggerMode
                                          .tap, // tooltip text
                                      child: Icon(Icons.help_outline),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: SizedBox(
                                      width: 60,
                                      height: 40,
                                      child: Center(
                                        child: TextField(
                                          controller: valueN,
                                          maxLength: 3,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 18),
                                          decoration: const InputDecoration(
                                            labelText: 'N',
                                            counterText: '',
                                            labelStyle: TextStyle(fontSize: 15),
                                            focusedBorder: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: SizedBox(
                                      width: 60,
                                      height: 40,
                                      child: TextField(
                                        controller: valueP,
                                        maxLength: 3,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          labelText: 'P',
                                          counterText: '',
                                          labelStyle: TextStyle(fontSize: 15),
                                          focusedBorder: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: SizedBox(
                                      width: 60,
                                      height: 40,
                                      child: TextField(
                                        controller: valueK,
                                        maxLength: 3,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          labelText: 'K',
                                          counterText: '',
                                          labelStyle: TextStyle(fontSize: 15),
                                          focusedBorder: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.all(0.0),
                                        elevation: 0.0,
                                      ),
                                      onPressed: () {
                                        int setN = int.parse(valueN.text);
                                        int setP = int.parse(valueP.text);
                                        int setK = int.parse(valueK.text);
                                        databaseReference
                                            .child('ESP32/setControl/NPK/N')
                                            .set(setN);
                                        databaseReference
                                            .child('ESP32/setControl/NPK/P')
                                            .set(setP);
                                        databaseReference
                                            .child('ESP32/setControl/NPK/K')
                                            .set(setK);
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 24, 116, 24),
                                              Color.fromARGB(255, 26, 160, 26),
                                              Color.fromARGB(255, 24, 156, 24),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 100.0, minHeight: 40.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Submit",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
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
                                      //_saveSwitchState('_statusAuto', value);
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
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
                                      //_saveSwitchState('isSwitched', value);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        roundedButton(
                            title: 'Set Time',
                            color: const Color.fromARGB(255, 24, 116, 24)),
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Set Time On',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                                    text: "Set Start",
                                    colors: [
                                      const Color.fromARGB(255, 24, 116, 24),
                                      const Color.fromARGB(255, 26, 160, 26),
                                      const Color.fromARGB(255, 24, 156, 24)
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
    required String textLong,
  }) {
    return CircularPercentIndicator(
      radius: 80,
      lineWidth: 16,
      percent: percentWheel,
      backgroundWidth: 10,
      backgroundColor: Colors.deepPurple.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      rotateLinearGradient: true,
      maskFilter: const MaskFilter.blur(BlurStyle.solid, 5.0),
      linearGradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 25, 92, 179),
          Color.fromARGB(255, 14, 100, 212),
          Color.fromARGB(255, 3, 108, 245),
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
              color: Color.fromARGB(255, 24, 116, 24),
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
