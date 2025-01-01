class ValidationUtils {
  static String? validateMinLength(
      String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor Telepon tidak boleh kosong';
    }
    if (value.length < 11) {
      return 'Nomor Telepon minimal 11 karakter';
    }
    if (!value.startsWith('08')) {
      return 'Nomor Telepon harus diawali dengan 08';
    }
    return null;
  }
}
