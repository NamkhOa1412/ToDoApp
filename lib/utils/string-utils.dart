import 'package:intl/intl.dart';


class StringUtils {

  static String formatDateToString(DateTime date) {
    String _result = '';
    _result = '${DateFormat('HH:MM  dd/MM/yyyy').format(date).toString()}';
    return _result;
  }

  static String formatDate(String isoString) {
    final date = DateTime.parse(isoString).toLocal(); // chuyển về giờ VN
    return "${date.day.toString().padLeft(2,'0')}/"
          "${date.month.toString().padLeft(2,'0')}/"
          "${date.year} "
          "${date.hour.toString().padLeft(2,'0')}:"
          "${date.minute.toString().padLeft(2,'0')}";
  }

  static String formatTimer(String isoString) {
    final date = DateTime.parse(isoString); // chuyển về giờ VN
    return "${date.day.toString().padLeft(2,'0')}/"
          "${date.month.toString().padLeft(2,'0')}/"
          "${date.year} "
          "${date.hour.toString().padLeft(2,'0')}:"
          "${date.minute.toString().padLeft(2,'0')}";
  }
}
