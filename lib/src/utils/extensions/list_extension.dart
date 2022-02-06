// ignore_for_file: unused_element

extension ListExtension on List {
  bool equals(List list) {
    if (length != list.length) return false;
    return every((item) => list.contains(item));
  }
}
