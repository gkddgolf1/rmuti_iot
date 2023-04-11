// To parse this JSON data, do
//
//     final esp32 = esp32FromJson(jsonString);

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
        required this.trTs,
        required this.setAutoMode,
        required this.setControl,
    });

    Bh1750 bh1750;
    E18D80Nk e18D80Nk;
    Rs485 rs485;
    Rtc1307 rtc1307;
    TrTs trTs;
    SetMode setAutoMode;
    SetControl setControl;

    factory Esp32.fromJson(Map<String, dynamic> json) => Esp32(
        bh1750: Bh1750.fromJson(json["BH1750"]),
        e18D80Nk: E18D80Nk.fromJson(json["E18-D80NK"]),
        rs485: Rs485.fromJson(json["RS485"]),
        rtc1307: Rtc1307.fromJson(json["RTC1307"]),
        trTs: TrTs.fromJson(json["TrTs"]),
        setAutoMode: SetMode.fromJson(json["setAutoMode"]),
        setControl: SetControl.fromJson(json["setControl"]),
    );

    Map<String, dynamic> toJson() => {
        "BH1750": bh1750.toJson(),
        "E18-D80NK": e18D80Nk.toJson(),
        "RS485": rs485.toJson(),
        "RTC1307": rtc1307.toJson(),
        "TrTs": trTs.toJson(),
        "setAutoMode": setAutoMode.toJson(),
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

class E18D80Nk {
    E18D80Nk({
        required this.val,
    });

    int val;

    factory E18D80Nk.fromJson(Map<String, dynamic> json) => E18D80Nk(
        val: json["val"],
    );

    Map<String, dynamic> toJson() => {
        "val": val,
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

class SetControl {
    SetControl({
        required this.motor,
        required this.pump,
        required this.setDateTime,
        required this.setTimerMode,
    });

    Motor motor;
    Pump pump;
    SetDateTime setDateTime;
    SetMode setTimerMode;

    factory SetControl.fromJson(Map<String, dynamic> json) => SetControl(
        motor: Motor.fromJson(json["MOTOR"]),
        pump: Pump.fromJson(json["PUMP"]),
        setDateTime: SetDateTime.fromJson(json["setDateTime"]),
        setTimerMode: SetMode.fromJson(json["setTimerMode"]),
    );

    Map<String, dynamic> toJson() => {
        "MOTOR": motor.toJson(),
        "PUMP": pump.toJson(),
        "setDateTime": setDateTime.toJson(),
        "setTimerMode": setTimerMode.toJson(),
    };
}

class Motor {
    Motor({
        required this.left,
        required this.right,
        required this.setTimeStart,
        required this.setTimeStop,
    });

    int left;
    int right;
    SetTimeSt setTimeStart;
    SetTimeSt setTimeStop;

    factory Motor.fromJson(Map<String, dynamic> json) => Motor(
        left: json["left"],
        right: json["right"],
        setTimeStart: SetTimeSt.fromJson(json["setTimeStart"]),
        setTimeStop: SetTimeSt.fromJson(json["setTimeStop"]),
    );

    Map<String, dynamic> toJson() => {
        "left": left,
        "right": right,
        "setTimeStart": setTimeStart.toJson(),
        "setTimeStop": setTimeStop.toJson(),
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
    });

    SetTimeSt setTimeStart;
    SetTimeSt setTimeStop;

    factory Pump.fromJson(Map<String, dynamic> json) => Pump(
        setTimeStart: SetTimeSt.fromJson(json["setTimeStart"]),
        setTimeStop: SetTimeSt.fromJson(json["setTimeStop"]),
    );

    Map<String, dynamic> toJson() => {
        "setTimeStart": setTimeStart.toJson(),
        "setTimeStop": setTimeStop.toJson(),
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
        required this.status,
    });

    int soilMoisture;
    int status;

    factory TrTs.fromJson(Map<String, dynamic> json) => TrTs(
        soilMoisture: json["soil_moisture"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "soil_moisture": soilMoisture,
        "status": status,
    };
}
