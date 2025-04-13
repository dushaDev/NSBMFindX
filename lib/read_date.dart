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
  //"2025/3/27/20/13" to "2025 march 27"
  String getDateStringToDisplay(String dateTimeStr) {
    try {
      final parts = dateTimeStr.split('/');
      if (parts.length != 5) throw FormatException("Invalid date format");

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      final monthNames = [
        "", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ];

      return '$year ${monthNames[month]} $day';
    } catch (e) {
      throw FormatException("Failed to parse date: $e");
    }
  }
  //"2025/3/27/20/13" to "08:13 PM"
  String getTimeStringToDisplay(String dateTimeStr) {
    try {
      final parts = dateTimeStr.split('/');
      if (parts.length != 5) throw FormatException("Invalid time format");

      final hour = int.parse(parts[3]);
      final minute = int.parse(parts[4]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      final paddedMinute = minute.toString().padLeft(2, '0');

      return '$displayHour:$paddedMinute $period';
    } catch (e) {
      throw FormatException("Failed to parse time: $e");
    }
  }

  String getWishStatement() {
    int hour = _dateTime.hour;
    if (hour >= 0 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 16) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }
}
