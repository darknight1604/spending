class IterableUtil {
  static bool isNullOrEmpty(Iterable? list) => list == null || list.isEmpty;

  static bool isNotNullOrEmpty(Iterable? list) => !isNullOrEmpty(list);
}
