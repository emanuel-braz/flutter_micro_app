import 'package:flutter/material.dart';

import '../../presentation/widgets/micro_overlay.dart';
import '../../utils/typedefs.dart';
import '../navigators/navigator_controller.dart';

class MicroAppOverlayController extends ChangeNotifier {
  final String route;
  late MicroAppOverlay fragment;
  OverlayEntry? entry;

  double _x = 0;
  double get x => _x;
  set x(double value) {
    _x = value;
    notifyListeners();
  }

  double _y = 0;
  double get y => _y;
  set y(double value) {
    _y = value;
    notifyListeners();
  }

  late bool _isDraggable;
  bool get isDraggable => _isDraggable;
  set isDraggable(bool value) {
    _isDraggable = value;
    notifyListeners();
  }

  late Size _size;
  Size get size => _size;
  set size(Size size) {
    _size = size;
    notifyListeners();
  }

  MicroAppOverlayController(
      {required this.route,
      Offset? position,
      Size size = const Size(10, 10),
      bool isDraggable = false}) {
    x = position?.dx ?? 0;
    y = position?.dy ?? 0;
    _isDraggable = isDraggable;
    _size = size;
  }

  void open({MicroAppFloatPageBuilder? builder}) {
    entry ??= OverlayEntry(
      maintainState: true,
      opaque: false,
      builder: (context) {
        return MicroAppOverlay(
          controller: this,
          builder: builder,
        );
      },
    );
    NavigatorInstance.nav.overlay?.insert(entry!);
  }

  void close() {
    if (entry != null) {
      entry?.remove();
    }
  }
}
