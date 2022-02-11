import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/src/controllers/navigators/navigator_controller.dart';
import 'package:flutter_micro_app/src/utils/typedefs.dart';

import 'micro_overlay.dart';

class MicroAppOverlayController extends ChangeNotifier {
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

  final String route;
  Size size;
  bool isDraggable;

  late MicroAppOverlay fragment;

  OverlayEntry? entry;

  MicroAppOverlayController(
      {required this.route,
      Offset? position,
      this.size = const Size(10, 10),
      this.isDraggable = false}) {
    x = position?.dx ?? 0;
    y = position?.dy ?? 0;
  }

  void open({MicroAppFloatPageBuilder? builder}) {
    if (entry == null) {
      entry = OverlayEntry(
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
  }

  void close() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
  }

  void setSize(Size size) {
    this.size = size;
    notifyListeners();
  }

  void maximize(BuildContext context) {
    x = 0;
    y = 0;
    size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    notifyListeners();
  }
}
