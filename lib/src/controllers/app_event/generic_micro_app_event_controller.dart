import 'package:flutter/foundation.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

abstract class GenericMicroAppEventController {
  final String? methodChannel;

  late final MicroAppEventController microAppEventController;
  GenericMicroAppEventController(
      {this.methodChannel, MicroAppEventController? eventController})
      : microAppEventController =
            eventController ?? MicroAppEventController.instance;

  @mustCallSuper
  void onEvent(MicroAppEvent? event) {
    if (event != null) microAppEventController.emit(event);
  }

  Future<Object?> emit(Object event, {Duration? timeout});
}
