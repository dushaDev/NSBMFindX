import 'package:intl/intl.dart';

class Utils {
  static String getFormattedDateSimple(int time,{String dateFormat = "yyyy/MM/dd"}) {
    DateFormat newFormat = DateFormat(dateFormat);
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
