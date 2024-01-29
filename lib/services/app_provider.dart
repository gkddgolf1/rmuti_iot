import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  // HomeScreen
  dynamic _temp;
  dynamic _hum;

  // SoilMoistureScreen
  bool _status = false;
  bool _statusAuto = false;
  bool _isSwitched = false;
  int _speedPump = 0;
  int _setSoilmoisture = 0;
  int _soilMoisture = 0;

  // Fertilizer
  bool _fertilizerAuto = false;
  bool _setTimeFertilizer = false;
  int _setNPK = 0;
  int _fertilizer = 0;

  // Light
  bool _lightAuto = false;
  bool _setTimeLight = false;
/*   bool _halfDay = false;
  bool _fullDay = false; */
  int _lux = 0;
  int _statusOpen = 0;
  int _statusOff = 0;
  int _record = 0;
  int _setHour = 0;

  // อื่นๆ
  String _time = "";
  int _minConverter = 0;

  // Add getters for your state variables
  // HomeScreen
  dynamic get temperature => _temp;
  dynamic get humidity => _hum;

  // SoilMoistureScreen
  bool get status => _status;
  bool get statusAuto => _statusAuto;
  bool get isSwitched => _isSwitched;
  int get speedPump => _speedPump;
  int get setSoilmoisture => _setSoilmoisture;
  int get soilMoisture => _soilMoisture;

  // Fertilizer
  bool get fertilizerAuto => _fertilizerAuto;
  bool get setTimeFertilizer => _setTimeFertilizer;
  int get setNPK => _setNPK;
  int get fertilizer => _fertilizer;

  // Light
  bool get lightAuto => _lightAuto;
  bool get setTimeLight => _setTimeLight;
/*   bool get halfDay => _halfDay;
  bool get fullDay => _fullDay; */
  int get lux => _lux;
  int get statusOpen => _statusOpen;
  int get statusOff => _statusOff;
  int get record => _record;
  int get setHour => _setHour;

  // อื่นๆ
  String get time => _time;
  int get minConverter => _minConverter;

  AppProvider(BuildContext context) {
    updateTime(context);
    updateTemp(context);
    updateHum(context);
    updateStatus(context);
    updateStatusAuto(context);
    updateSwitched(context);
    updateSpeedPump(context);
    updateSetSoilmoisture(context);
    updateSoilMoisture(context);
    updateFertilizerAuto(context);
    updateSetTimeFertilizer(context);
    updateSetNPK(context);
    updateFertilizer(context);
    updateLightAuto(context);
    updateRecord(context);
    //updateSetHour(context);
    updateSetTimeLight(context);
/*     updateHalfDay(context);
    updateFullDay(context); */
    updateLight(context);
    updateStatusOpen(context);
    updateStatusOff(context);
    updateMinConverter(context);
  }

  bool isWidgetMounted(BuildContext context) {
    final state = context;
    return state.mounted;
  }

  // ------------------------------HomeScreen-----------------------------------//
  // ฟังก์ชันแสดงค่า Temp
  void updateTemp(BuildContext context) {
    _databaseReference
        .child('ESP32/views/SHT31/temperature')
        .onValue
        .listen((event) {
      dynamic temperature = (event.snapshot.value as dynamic);
      if (isWidgetMounted(context)) {
        _temp = temperature;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันแสดงค่า Hum
  void updateHum(BuildContext context) {
    _databaseReference
        .child('ESP32/views/SHT31/humidity')
        .onValue
        .listen((event) {
      dynamic humidity = (event.snapshot.value as dynamic);

      if (isWidgetMounted(context)) {
        _hum = humidity;
        notifyListeners();
      }
    });
  }

  // ------------------------------SoilMoisture-----------------------------------//

  // ฟังก์ชันรดน้ำต้นไม้
  void updateStatus(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/PUMP/status')
        .onValue
        .listen((event) {
      int status = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _status = status == 1;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันรดน้ำต้นไม้อัตโนมัติ
  void updateStatusAuto(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/setAutoMode/pump')
        .onValue
        .listen((event) {
      int statusAuto = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _statusAuto = statusAuto == 1;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันตั้งเวลารดน้ำ
  void updateSwitched(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/setTimerMode/pump')
        .onValue
        .listen((event) {
      int settime = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _isSwitched = (settime == 1);
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันปรับแรงดันน้ำ
  void updateSpeedPump(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/PUMP/speedPump')
        .onValue
        .listen((event) {
      int speedpump = (event.snapshot.value as int);

      if (isWidgetMounted(context)) {
        _speedPump = speedpump;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันตั้งค่าความชื้นดิน
  void updateSetSoilmoisture(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/PUMP/setSoilmoilsture')
        .onValue
        .listen((event) {
      int setSoilmoisture = (event.snapshot.value as int);

      if (isWidgetMounted(context)) {
        _setSoilmoisture = setSoilmoisture;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันอ่านค่าเซ็นเซอร์วัดความชื้นดิน
  void updateSoilMoisture(BuildContext context) {
    _databaseReference
        .child('ESP32/views/TrTs/soil_moisture')
        .onValue
        .listen((event) {
      int soilMoisture = (event.snapshot.value as int);

      if (isWidgetMounted(context)) {
        _soilMoisture = soilMoisture;
        notifyListeners();
      }
    });
  }

  // ------------------------------Fertilizer-----------------------------------//

  // ฟังก์ชันให้ปุ๋ยอัตโนมัติ
  void updateFertilizerAuto(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/setAutoMode/npk')
        .onValue
        .listen((event) {
      int autoFertilizer = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _fertilizerAuto = (autoFertilizer == 1);
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันตั้งเวลาให้ปุ๋ย
  void updateSetTimeFertilizer(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/setTimerMode/npk')
        .onValue
        .listen((event) {
      int settime = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _setTimeFertilizer = (settime == 1);
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันเซ็ทค่าปุ๋ย NPK
  void updateSetNPK(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/NPK/test')
        .onValue
        .listen((event) {
      int npk = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _setNPK = npk;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันอ่านค่าปุ๋ย
  void updateFertilizer(BuildContext context) {
    _databaseReference
        .child('ESP32/views/RS485/Fertility')
        .onValue
        .listen((event) {
      int fertility = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _fertilizer = fertility;
        notifyListeners();
      }
    });
  }

  // ------------------------------Light-----------------------------------//
  // ฟังก์ชันเปิด-ปิดม่านอัตโนมัติ
  void updateLightAuto(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/setAutoMode/motor')
        .onValue
        .listen((event) {
      int statusAuto = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _lightAuto = (statusAuto == 1);
        notifyListeners();
      }
    });
  }

/*   // ฟังก์ชันตั้งเวลาเปิด-ปิดม่าน
  void updateSetHour(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/MOTOR/setAuto/hour')
        .onValue
        .listen((event) {
      int setHour = event.snapshot.value as int;
      if (isWidgetMounted(context)) {
        _setHour = setHour;
        notifyListeners();
      }
    });
  } */

  // ฟังก์ชันตั้งเวลาเปิด-ปิดม่าน
  void updateRecord(BuildContext context) {
    _databaseReference
        .child('ESP32/views/Lux_Record/min_today')
        .onValue
        .listen((event) {
      int record = event.snapshot.value as int;
      if (isWidgetMounted(context)) {
        _record = record;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันตั้งเวลาเปิด-ปิดม่าน
  void updateSetTimeLight(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/setTimerMode/motor')
        .onValue
        .listen((event) {
      int settime = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _setTimeLight = (settime == 1);
        notifyListeners();
      }
    });
  }

  /*  // ฟังก์ชันการตั้งค่าครึ่งวัน
  void updateHalfDay(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/MOTOR/setAuto/halfDay')
        .onValue
        .listen((event) {
      int halfday = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _halfDay = (halfday == 1);
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันการตั้งค่าเต็มวัน
  void updateFullDay(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/MOTOR/setAuto/fullDay')
        .onValue
        .listen((event) {
      int fullday = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _fullDay = (fullday == 1);
        notifyListeners();
      }
    });
  } */

  // ฟังก์ชันอ่านค่าเซ็นเซอร์แสง
  void updateLight(BuildContext context) {
    _databaseReference.child('ESP32/views/BH1750/Lux').onValue.listen((event) {
      int lux = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _lux = lux;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันอ่านค่าเซ็นเซอร์แสง
  void updateStatusOpen(BuildContext context) {
    _databaseReference
        .child('ESP32/views/LIMIT_SW/status')
        .onValue
        .listen((event) {
      int status = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _statusOpen = status;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันอ่านค่าเซ็นเซอร์แสง
  void updateStatusOff(BuildContext context) {
    _databaseReference
        .child('ESP32/views/TCS-34725/status')
        .onValue
        .listen((event) {
      int status = (event.snapshot.value as int);
      if (isWidgetMounted(context)) {
        _statusOff = status;
        notifyListeners();
      }
    });
  }

  // ฟังก์ชันดึงค่าเวลา
  void updateTime(BuildContext context) {
    _databaseReference
        .child('ESP32/views/RTC1307/Time')
        .onValue
        .listen((event) {
      var time = event.snapshot.value;

      if (isWidgetMounted(context)) {
        _time = time.toString();
        notifyListeners();
      }
    });
  }

  // ------------------------------other-----------------------------------//
  void updateMinConverter(BuildContext context) {
    _databaseReference
        .child('ESP32/setControl/MOTOR/minConverter')
        .onValue
        .listen((event) {
      int minConverter = event.snapshot.value as int;
      if (isWidgetMounted(context)) {
        _minConverter = minConverter;
        notifyListeners();
      }
    });
  }
}
