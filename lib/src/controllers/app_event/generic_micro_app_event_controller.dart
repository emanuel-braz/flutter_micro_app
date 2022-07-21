import 'package:flutter/foundation.dart';

import '../../../flutter_micro_app.dart';

abstract class GenericMicroAppEventController {
  /// methodChannel
  final String? methodChannel;

  /// name
  String? name;

  /// description
  String? description;

  /// parentName
  String? parentName;

  late final MicroAppEventController _microAppEventController;
  GenericMicroAppEventController(
      {this.methodChannel, MicroAppEventController? eventController})
      : _microAppEventController =
            eventController ?? MicroAppEventController.instance;

  /// When recieve event
  @mustCallSuper
  void onEvent(MicroAppEvent? event) {
    if (event != null) _microAppEventController.emit(event);
  }

  /// emit events
  Future<Object?> emit(Object event, {Duration? timeout});

  /// dispose controller
  void dispose();
}
