import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../dependencies.dart';
import '../../../../flutter_micro_app.dart';
import 'micro_app_event_adapter.dart';

/// MethodCall arguments
///
/// Json example:
/// ```json
/// {
///  "name": "", // Required
///  "payload": {}, // Optional
///  "distinct": true, // Optional
///  "channels": [], // Optional
///  "version": "1.0.0", // Optional
///  "datetime": "2020-01-01T00:00:00.000Z" // Optional
/// }
/// ```
///
/// If the json parse fails, it will return a default [MicroAppEvent]:
/// ```dart
/// return MicroAppEvent(
///   name: methodCall.method,
///   payload: methodCall.arguments,
///   distinct: true,
///   channels: [],
///   datetime: DateTime.now(),
/// );
/// ```
class MicroAppEventJsonAdapter implements MicroAppEventAdapter {
  @override
  MicroAppEvent parse(MethodCall methodCall) {
    try {
      final type = methodCall.arguments.runtimeType;
      final map = type == String
          ? jsonDecode(methodCall.arguments)
          : methodCall.arguments;
      final name = map['name'] ?? methodCall.method;
      final payload = map['payload'];
      final distinct = map['distinct'] ?? true;
      final version = map['version'];
      final datetime = map['datetime'] != null
          ? DateTime.tryParse(map['datetime'] ?? '')
          : null;

      List<dynamic>? list = map['channels'];
      final channels =
          list != null ? list.map((e) => e.toString()).toList() : <String>[];

      return MicroAppEvent(
          name: name,
          payload: payload,
          distinct: distinct,
          channels: channels,
          version: version,
          datetime: datetime);
    } catch (e) {
      l.e('MicroAppEventJsonAdapter', error: e);
      return MicroAppEvent(
        name: methodCall.method,
        payload: methodCall.arguments,
      );
    }
  }
}
