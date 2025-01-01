import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToLocaleDate(String date) {
    final parts = date.split('/');
    final dateObj = DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );

    return DateFormat('d MMMM y', 'id_ID').format(dateObj);
  }

  static String getStartDate(String dueDate) {
    final parts = dueDate.split('/');
    final dueDateObj = DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );

    final startDate = dueDateObj.subtract(const Duration(days: 30));
    return DateFormat('d MMMM y', 'id_ID').format(startDate);
  }
}
