import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final databaseReference = FirebaseDatabase.instance.ref();

  TextEditingController temp1 = TextEditingController();
  TextEditingController hum1 = TextEditingController();
  TextEditingController hour1 = TextEditingController();
  TextEditingController minute1 = TextEditingController();
  TextEditingController soilMoisture1 = TextEditingController();
  TextEditingController pumpCon1 = TextEditingController();
  TextEditingController soilCon1 = TextEditingController();
  TextEditingController waterCon1 = TextEditingController();
  TextEditingController pumpAuto1 = TextEditingController();
  TextEditingController startWaterHour1 = TextEditingController();
  TextEditingController startWaterMinute1 = TextEditingController();
  TextEditingController stopWaterHour1 = TextEditingController();
  TextEditingController stopWaterMinute1 = TextEditingController();
  TextEditingController fertilizer1 = TextEditingController();
  TextEditingController fertilizerCon1 = TextEditingController();
  TextEditingController fertilizerAuto1 = TextEditingController();
  TextEditingController startFerHour1 = TextEditingController();
  TextEditingController startFerMinute1 = TextEditingController();
  TextEditingController stopFerHour1 = TextEditingController();
  TextEditingController stopFerMinute1 = TextEditingController();
  TextEditingController light1 = TextEditingController();
  TextEditingController lightStatus1 = TextEditingController();
  TextEditingController lightSave1 = TextEditingController();
  TextEditingController lightConHour1 = TextEditingController();
  TextEditingController lightConMinute1 = TextEditingController();
  TextEditingController lightAuto1 = TextEditingController();
  TextEditingController startLightHour1 = TextEditingController();
  TextEditingController startLightMinute1 = TextEditingController();
  TextEditingController stopLightHour1 = TextEditingController();
  TextEditingController stopLightMinute1 = TextEditingController();

  void readData(Function(String) onData, BuildContext context) {
    databaseReference.child("esp").onValue.listen((event) {
      var snapshot = event.snapshot;
      var strCommand = snapshot.value.toString();
      if (strCommand != "0") {
        var arrCommand = strCommand.split(",");

        if (arrCommand[0] == "1") {
          temp1.text = arrCommand[1];
          hum1.text = arrCommand[2];
        } else if (arrCommand[0] == "2") {
          hour1.text = arrCommand[1];
          minute1.text = arrCommand[2];
        } else if (arrCommand[0] == "3") {
          soilMoisture1.text = arrCommand[1];
        } else if (arrCommand[0] == "4") {
          pumpCon1.text = arrCommand[1];
          soilCon1.text = arrCommand[2];
        } else if (arrCommand[0] == "6") {
          waterCon1.text = arrCommand[1];
        } else if (arrCommand[0] == "8") {
          pumpAuto1.text = arrCommand[1];
        } else if (arrCommand[0] == "A") {
          startWaterHour1.text = arrCommand[1];
          startWaterMinute1.text = arrCommand[2];
          stopWaterHour1.text = arrCommand[3];
          stopWaterMinute1.text = arrCommand[4];
        } else if (arrCommand[0] == "C") {
          fertilizer1.text = arrCommand[1];
        } else if (arrCommand[0] == "D") {
          fertilizerCon1.text = arrCommand[1];
        } else if (arrCommand[0] == "F") {
          fertilizerAuto1.text = arrCommand[1];
        } else if (arrCommand[0] == "H") {
          startFerHour1.text = arrCommand[1];
          startFerMinute1.text = arrCommand[2];
          stopFerHour1.text = arrCommand[3];
          stopFerMinute1.text = arrCommand[4];
        } else if (arrCommand[0] == "J") {
          light1.text = arrCommand[1];
        } else if (arrCommand[0] == "K") {
          lightStatus1.text = arrCommand[1];
          lightSave1.text = arrCommand[2];
        } else if (arrCommand[0] == "L") {
          lightConHour1.text = arrCommand[1];
          lightConMinute1.text = arrCommand[2];
        } else if (arrCommand[0] == "N") {
          startLightHour1.text = arrCommand[1];
          startLightMinute1.text = arrCommand[2];
          stopLightHour1.text = arrCommand[3];
          stopLightMinute1.text = arrCommand[4];
        } else {
          print("Succes");
        }

        databaseReference.child("comm").set("0");
        databaseReference.child("esp").set("0");
      }
    });
  }

  void readTempHum() {
    String strCommand = "1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readTime() {
    String strCommand = "2";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readSoilMois() {
    String strCommand = "3";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readPumpSoilCon() {
    String strCommand = "4";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setPumpSoilCon(String pumpCon1, String soilCon1) {
    String strCommand = "5,$pumpCon1,$soilCon1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readWaterCon() {
    String strCommand = "6";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setWaterCon(String waterCon1) {
    String strCommand = "7,$waterCon1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readPumpAuto() {
    String strCommand = "8";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setPumpAuto() {
    String strCommand = "9";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readPumpTimeCon() {
    String strCommand = "A";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setPumpTimeCon(String startWaterHour1, String startWaterMinute1,
      String stopWaterHour1, String stopWaterMinute1) {
    String strCommand =
        "B,$startWaterHour1,$startWaterMinute1,$stopWaterHour1,$stopWaterMinute1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readFertilizer() {
    String strCommand = "C";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readFertilizerCon() {
    String strCommand = "D";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setFertilizerCon(String fertilizerCon1) {
    String strCommand = "E,$fertilizerCon1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readFertilizerAuto() {
    String strCommand = "F";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setFertilizerAuto(String fertilizerAuto1) {
    String strCommand = "G,$fertilizerAuto1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readFerTimeCon() {
    String strCommand = "H";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setFerTimeCon(String startFerHour1, String startFerMinute1,
      String stopFerHour1, String stopFerMinute1) {
    String strCommand =
        "I,$startFerHour1,$startFerMinute1,$stopFerHour1,$stopFerMinute1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readLight() {
    String strCommand = "J";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readLightStatusSave() {
    String strCommand = "K";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readLightTimeCon() {
    String strCommand = "L";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setLightTimeCon(
      String lightConHour1, String lightConMinute1, String lightAuto1) {
    String strCommand = "M,$lightConHour1,$lightConMinute1,$lightAuto1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void readLightTimeOnOff() {
    String strCommand = "N";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }

  void setLightTimeOnOff(String startLightHour1, String startLightMinute1,
      String stopLightHour1, String stopLightMinute1) {
    String strCommand =
        "O,$startLightHour1,$startLightMinute1,$stopLightHour1,$stopLightMinute1";
    FirebaseDatabase.instance.ref().child("comm").set(strCommand);
  }
}
