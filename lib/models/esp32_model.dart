 class Rs489 {
  int n;
  int p;
  int k;

  Rs489.fromJson(Map<String, dynamic> json)
      : n = json['N'],
        p = json['P'],
        k = json['K'];

  Map<String, dynamic> toJson() => {'n': n, 'p': p, 'k': k};
}

class TrTs {
  int soil_moisture;
  int status;

  TrTs.fromJson(Map<String, dynamic> json)
      : soil_moisture = json['soil_moisture'],
        status = json['status'];

  Map<String, dynamic> toJson() =>
      {'soil_moisture': soil_moisture, 'status': status};
}

class SetTime {
  int hour;
  int minute;
  //int second;
  //int date;
  /* int day;
  int month;
  int year; */

  SetTime.fromJson(Map<String, dynamic> json)
      : hour = json['hour'],
        minute = json['minute'];
  //second = json['second'];
  //date = json['date'],
  //day = json['day'],
  //month = json['month'],
  //year = json['year'];

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        //'second': second,
        //'date': date,
        //'day': day,
        //'month': month,
        // 'year': year
      };
} 

class Bh1750 {
  int lux;

  Bh1750.fromJson(Map<String, dynamic> json) : lux = json['Lux'];

  Map<String, dynamic> toJson() => {'lux': lux};
}

 

/* class Esp32 {
  late int n;
  late int p;
  late int k;
  late int soilMoisture;
  late int status;
  late int hour;
  late int minute;
  late int lux;

  Esp32(
      {required this.n,
      required this.p,
      required this.k,
      required this.soilMoisture,
      required this.status,
      required this.hour,
      required this.minute,
      required this.lux});

  Esp32.fromJson(Map<String, dynamic> json)
      : n = json['N'],
        p = json['P'],
        k = json['K'],
        soilMoisture = json['soil_moisture'],
        status = json['status'],
        hour = json['hour'],
        minute = json['minute'],
        lux = json['Lux'];

  Map<String, dynamic> toJson() => {
        'n': n,
        'p': p,
        'k': k,
        'soilMoisture': soilMoisture,
        'status': status,
        'hour': hour,
        'minute': minute,
        'lux': lux
      };
} */
