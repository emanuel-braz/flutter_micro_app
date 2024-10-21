import 'package:flutter/foundation.dart';

class CustomValueNotifier<T> extends ValueNotifier<T> {
  CustomValueNotifier(T value) : super(value);

  void notifyValue(T newValue) {
    super.value = newValue;
    notifyListeners();
  }
}
