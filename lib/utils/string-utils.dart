import 'package:intl/intl.dart';


class StringUtils {

  static String formatDateToString(DateTime date) {
    String _result = '';
    _result = '${DateFormat('HH:MM  dd/MM/yyyy').format(date).toString()}';
    return _result;
  }
}
