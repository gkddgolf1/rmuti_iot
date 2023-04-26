// To parse this JSON data, do
//
//     final esp32 = esp32FromJson(jsonString);

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Esp32 esp32FromJson(String str) => Esp32.fromJson(json.decode(str));

String esp32ToJson(Esp32 data) => json.encode(data.toJson());

class Esp32 {
  Esp32({
    required this.bh1750,
    required this.e18D80Nk,
    required this.rs485,
    required this.rtc1307,
    required this.tcs34725,
    required this.trTs,
    required this.countRecord,
    required this.setControl,
  });

  Bh1750 bh1750;
  E18D80Nk e18D80Nk;
  Rs485 rs485;
  Rtc1307 rtc1307;
  E18D80Nk tcs34725;
  TrTs trTs;
  CountRecord countRecord;
  SetControl setControl;

  factory Esp32.fromJson(Map<String, dynamic> json) => Esp32(
        bh1750: Bh1750.fromJson(json["BH1750"]),
        e18D80Nk: E18D80Nk.fromJson(json["E18-D80NK"]),
        rs485: Rs485.fromJson(json["RS485"]),
        rtc1307: Rtc1307.fromJson(json["RTC1307"]),
        tcs34725: E18D80Nk.fromJson(json["TCS-34725"]),
        trTs: TrTs.fromJson(json["TrTs"]),
        countRecord: CountRecord.fromJson(json["count_Record"]),
        setControl: SetControl.fromJson(json["setControl"]),
      );

  Map<String, dynamic> toJson() => {
        "BH1750": bh1750.toJson(),
        "E18-D80NK": e18D80Nk.toJson(),
        "RS485": rs485.toJson(),
        "RTC1307": rtc1307.toJson(),
        "TCS-34725": tcs34725.toJson(),
        "TrTs": trTs.toJson(),
        "count_Record": countRecord.toJson(),
        "setControl": setControl.toJson(),
      };
}

class Bh1750 {
  Bh1750({
    required this.lux,
  });

  int lux;

  factory Bh1750.fromJson(Map<String, dynamic> json) => Bh1750(
        lux: json["Lux"],
      );

  Map<String, dynamic> toJson() => {
        "Lux": lux,
      };
}

class CountRecord {
  CountRecord({
    required this.min,
  });

  int min;

  factory CountRecord.fromJson(Map<String, dynamic> json) => CountRecord(
        min: json["min"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
      };
}

class E18D80Nk {
  E18D80Nk({
    required this.status,
  });

  int status;

  factory E18D80Nk.fromJson(Map<String, dynamic> json) => E18D80Nk(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class Rs485 {
  Rs485({
    required this.k,
    required this.n,
    required this.p,
  });

  int k;
  int n;
  int p;

  factory Rs485.fromJson(Map<String, dynamic> json) => Rs485(
        k: json["K"],
        n: json["N"],
        p: json["P"],
      );

  Map<String, dynamic> toJson() => {
        "K": k,
        "N": n,
        "P": p,
      };
}

class Rtc1307 {
  Rtc1307({
    required this.date,
    required this.time,
  });

  String date;
  String time;

  factory Rtc1307.fromJson(Map<String, dynamic> json) => Rtc1307(
        date: json["Date"],
        time: json["Time"],
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "Time": time,
      };
}

class SetControl {
  SetControl({
    required this.motor,
    required this.pump,
    required this.setAutoMode,
    required this.setDateTime,
    required this.setTimerMode,
  });

  Motor motor;
  Pump pump;
  SetMode setAutoMode;
  SetDateTime setDateTime;
  SetMode setTimerMode;

  factory SetControl.fromJson(Map<String, dynamic> json) => SetControl(
        motor: Motor.fromJson(json["MOTOR"]),
        pump: Pump.fromJson(json["PUMP"]),
        setAutoMode: SetMode.fromJson(json["setAutoMode"]),
        setDateTime: SetDateTime.fromJson(json["setDateTime"]),
        setTimerMode: SetMode.fromJson(json["setTimerMode"]),
      );

  Map<String, dynamic> toJson() => {
        "MOTOR": motor.toJson(),
        "PUMP": pump.toJson(),
        "setAutoMode": setAutoMode.toJson(),
        "setDateTime": setDateTime.toJson(),
        "setTimerMode": setTimerMode.toJson(),
      };
}

class Motor {
  Motor({
    required this.left,
    required this.right,
    required this.setAuto,
    required this.setTimeStart,
    required this.setTimeStop,
  });

  int left;
  int right;
  SetAuto setAuto;
  SetTimeSt setTimeStart;
  SetTimeSt setTimeStop;

  factory Motor.fromJson(Map<String, dynamic> json) => Motor(
        left: json["left"],
        right: json["right"],
        setAuto: SetAuto.fromJson(json["setAuto"]),
        setTimeStart: SetTimeSt.fromJson(json["setTimeStart"]),
        setTimeStop: SetTimeSt.fromJson(json["setTimeStop"]),
      );

  Map<String, dynamic> toJson() => {
        "left": left,
        "right": right,
        "setAuto": setAuto.toJson(),
        "setTimeStart": setTimeStart.toJson(),
        "setTimeStop": setTimeStop.toJson(),
      };
}

class SetAuto {
  SetAuto({
    required this.fullDay,
    required this.halfDay,
  });

  int fullDay;
  int halfDay;

  factory SetAuto.fromJson(Map<String, dynamic> json) => SetAuto(
        fullDay: json["fullDay"],
        halfDay: json["halfDay"],
      );

  Map<String, dynamic> toJson() => {
        "fullDay": fullDay,
        "halfDay": halfDay,
      };
}

class SetTimeSt {
  SetTimeSt({
    required this.hour,
    required this.minute,
  });

  int hour;
  int minute;

  factory SetTimeSt.fromJson(Map<String, dynamic> json) => SetTimeSt(
        hour: json["hour"],
        minute: json["minute"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
}

class Pump {
  Pump({
    required this.setTimeStart,
    required this.setTimeStop,
    required this.status,
  });

  SetTimeSt setTimeStart;
  SetTimeSt setTimeStop;
  int status;

  factory Pump.fromJson(Map<String, dynamic> json) => Pump(
        setTimeStart: SetTimeSt.fromJson(json["setTimeStart"]),
        setTimeStop: SetTimeSt.fromJson(json["setTimeStop"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "setTimeStart": setTimeStart.toJson(),
        "setTimeStop": setTimeStop.toJson(),
        "status": status,
      };
}

class SetMode {
  SetMode({
    required this.motor,
    required this.npk,
    required this.pump,
  });

  int motor;
  int npk;
  int pump;

  factory SetMode.fromJson(Map<String, dynamic> json) => SetMode(
        motor: json["motor"],
        npk: json["npk"],
        pump: json["pump"],
      );

  Map<String, dynamic> toJson() => {
        "motor": motor,
        "npk": npk,
        "pump": pump,
      };
}

class SetDateTime {
  SetDateTime({
    required this.day,
    required this.hour,
    required this.minute,
    required this.month,
    required this.year,
  });

  int day;
  int hour;
  int minute;
  int month;
  int year;

  factory SetDateTime.fromJson(Map<String, dynamic> json) => SetDateTime(
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "hour": hour,
        "minute": minute,
        "month": month,
        "year": year,
      };
}

class TrTs {
  TrTs({
    required this.soilMoisture,
  });

  int soilMoisture;

  factory TrTs.fromJson(Map<String, dynamic> json) => TrTs(
        soilMoisture: json["soil_moisture"],
      );

  Map<String, dynamic> toJson() => {
        "soil_moisture": soilMoisture,
      };
}
