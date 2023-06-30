class StringUtil {
  static bool isNotNullOrEmpty(String? value) =>
      value != null && value.isNotEmpty;

  static bool isNullOrEmpty(String? value) => !isNotNullOrEmpty(value);
}
