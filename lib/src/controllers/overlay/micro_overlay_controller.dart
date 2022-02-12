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

  Size get size => Size(_width, _height);
  set size(Size size) {
    _width = size.width;
    _height = size.height;
    notifyListeners();
  }

  double _width = 0;
  double get width => _width;
  set width(double value) {
    _width = value;
    notifyListeners();
  }

  double _height = 0;
  double get height => _height;
  set height(double value) {
    _height = value;
    notifyListeners();
  }

  MicroAppOverlayController(
      {required this.route,
      Offset? position,
      Size size = const Size(double.infinity, double.infinity),
      bool isDraggable = false}) {
    x = position?.dx ?? 0;
    y = position?.dy ?? 0;
    _isDraggable = isDraggable;
    this.size = size;
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
