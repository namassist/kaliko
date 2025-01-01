import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID', // Locale Indonesia
    symbol: 'Rp ', // Simbol mata uang
    decimalDigits: 0, // Tanpa angka desimal
  );
  return formatter.format(value);
}
