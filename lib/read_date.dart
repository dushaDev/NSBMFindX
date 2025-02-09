class ReadDate {
  final DateTime _dateTime = DateTime.now();

  String getDuration(String oldDate) {
    List<int> parts = calculateDate(oldDate.split('/'));
    int yyyy = parts[0];
    int mm = parts[1];
    int dd = parts[2];
    int hh = parts[3];
    int min = parts[4];

    if (yyyy > 0) {
      return "$yyyy years";
    } else if (mm > 0) {
      return "$mm months";
    } else if (dd > 0) {
      return "$dd days";
    } else if (hh > 0) {
      return "$hh hours";
    } else if (min > 0) {
      return "$min min";
    } else {
      return "Just now";
    }
  }

  String getDateNow() {
    return "${_dateTime.year}/${_dateTime.month}/${_dateTime.day}/${_dateTime.hour}/${_dateTime.minute}";
  }

  List<int> calculateDate(List<String> parts) {
    int strY = int.parse(parts[0]);
    int strM = int.parse(parts[1]);
    int strD = int.parse(parts[2]);
    int strH = int.parse(parts[3]);
    int strMi = int.parse(parts[4]);
    int yyyy = 0;
    int mm = 0;
    int dd = 0;
    int hh = 0;
    int min = 0;
    int nowYyyy = _dateTime.year;
    int nowMm = _dateTime.month;
    int nowDd = _dateTime.day;
    int nowHh = _dateTime.hour;
    int nowMin = _dateTime.minute;

    if (nowMin >= strMi) {
      min = nowMin - strMi;
    } else {
      nowHh--;
      min = (nowMin + 60) - strMi;
    }
    if (nowHh >= strH) {
      hh = nowHh - strH;
    } else {
      nowDd--;
      hh = (nowHh + 24) - strH;
    }
    if (nowDd >= strD) {
      dd = nowDd - strD;
    } else {
      nowMm--;
      dd = (nowDd + 30) - strD;
    }
    if (nowMm >= strM) {
      mm = nowMm - strM;
    } else {
      nowYyyy--;
      mm = (nowMm + 12) - strM;
    }
    if (nowYyyy >= strY) {
      yyyy = nowYyyy - strY;
    } else {
      yyyy = -1;
      mm = -1;
      dd = -1;
      hh = -1;
      min = -1;
    }

    List<int> calculatedDate = [];
    calculatedDate.add(yyyy);
    calculatedDate.add(mm);
    calculatedDate.add(dd);
    calculatedDate.add(hh);
    calculatedDate.add(min);

    return calculatedDate;
  }
}
