import 'package:flutter/foundation.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

abstract class GenericMicroAppEventController {
  final String? methodChannel;
  String? name;
  String? description;
  String? parentName;

  late final MicroAppEventController _microAppEventController;
  GenericMicroAppEventController(
      {this.methodChannel, MicroAppEventController? eventController})
      : _microAppEventController =
            eventController ?? MicroAppEventController.instance;

  @mustCallSuper
  void onEvent(MicroAppEvent? event) {
    if (event != null) _microAppEventController.emit(event);
  }

  Future<Object?> emit(Object event, {Duration? timeout});

  void dispose();
}
