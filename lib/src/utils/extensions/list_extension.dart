extension ListExtension on List {
  bool equals(List list) {
    if (length != list.length) return false;
    return every((item) => list.contains(item));
  }
}

extension ListFutureExtension on List<Future> {
  Future getFirstResult() {
    return Future.any(this);
  }
}
