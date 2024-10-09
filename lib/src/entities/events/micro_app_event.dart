import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_log/dart_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

/// Event channels
@pragma('vm:entry-point')
abstract class EventChannelsEquatable extends Equatable {
  final List<String> channels;
  const EventChannelsEquatable(this.channels);
}

/// [MicroAppEvent]
@pragma('vm:entry-point')
class MicroAppEvent<T> extends EventChannelsEquatable {
  final String? name;
  final T? payload;
  final bool distinct;
  final MethodCall? methodCall;
  final String? version;
  final DateTime datetime;
  final Completer _completer = Completer();

  MicroAppEvent({
    List<String> channels = const [],
    DateTime? datetime,
    this.name,
    this.payload,
    this.distinct = true,
    this.methodCall,
    this.version,
  })  : datetime = datetime ?? DateTime.now(),
        super(channels);

  // Verify if the event's origin is a [MethodCall]
  bool get hasMethodCall => methodCall != null;

  T? cast() {
    try {
      return payload as T;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    try {
      return jsonEncode({
        'name': name,
        'payload': payload?.toString(),
        'channels': channels,
        'distinct': distinct,
        'methodCall':
            methodCall.toString() != 'null' ? methodCall.toString() : null,
        'version': version,
        'datetime': datetime.toIso8601String()
      });
    } catch (e) {
      return super.toString();
    }
  }

  /// [MicroAppEvent.copyWith]
  MicroAppEvent<T> copyWith({
    String? name,
    T? payload,
    bool? distinct,
    MethodCall? methodCall,
    String? version,
    DateTime? datetime,
    List<String>? channels,
  }) {
    return MicroAppEvent<T>(
        name: name ?? this.name,
        payload: payload ?? this.payload,
        distinct: distinct ?? this.distinct,
        methodCall: methodCall ?? this.methodCall,
        version: version ?? this.version,
        datetime: datetime ?? this.datetime,
        channels: channels ?? this.channels);
  }

  MicroAppEvent<D?> copyWithTyped<D>({
    String? name,
    D? payload,
    bool? distinct,
    MethodCall? methodCall,
    String? version,
    DateTime? datetime,
  }) {
    return MicroAppEvent<D?>(
        name: name ?? this.name,
        payload: payload as D ?? this.payload as D,
        distinct: distinct ?? this.distinct,
        methodCall: methodCall ?? this.methodCall,
        version: version ?? this.version,
        datetime: datetime ?? this.datetime,
        channels: channels);
  }

  Type get type => payload.runtimeType;

  /// Completes with success
  void resultSuccess([FutureOr<dynamic>? value]) {
    if (!_completer.isCompleted) {
      _completer.complete(value);
    }
  }

  /// Completes with error
  void resultError(Object error, [StackTrace? stackTrace]) =>
      _completer.completeError(error, stackTrace);

  /// Returns a Future
  ///
  /// Use `event.resultSuccess(value)` or `event.resultError(error)` in order to complete this `Future`
  Future get asFuture => _completer.future;

  @override
  List<Object?> get props =>
      [name, payload, channels, distinct, hasMethodCall, version];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'payload': payload?.toString(),
      'channels': channels,
      'distinct': distinct,
      'version': version,
      'datetime': datetime.toIso8601String(),
    };
  }

  factory MicroAppEvent.fromMap(Map<String, dynamic> map) {
    List<dynamic>? list = map['channels'];
    final channels =
        list != null ? list.map((e) => e.toString()).toList() : <String>[];

    return MicroAppEvent<T>(
      name: map['name'] ?? '',
      payload: map['payload'],
      distinct: map['distinct'] ?? false,
      version: map['version'],
      datetime: DateTime.tryParse(map['datetime'] ?? '') ?? DateTime.now(),
      channels: channels,
    );
  }

  String toJson() => json.encode(toMap());

  static MicroAppEvent<T>? fromJson<T>(String source) {
    try {
      return MicroAppEvent<T>.fromMap(json.decode(source));
    } catch (e) {
      logger.e('[MicroAppEvent]: error parsing json', error: e);
      return null;
    }
  }

  dynamic copyTyped() {
    if (type == <String, dynamic>{}.runtimeType) {
      return copyWithTyped<Map<String, dynamic>?>();
    } else if (type == <dynamic, dynamic>{}.runtimeType) {
      return copyWithTyped<Map<dynamic, dynamic>?>();
    } else if (type == <String, String>{}.runtimeType) {
      return copyWithTyped<Map<String, String>?>();
    } else if (type == bool) {
      return copyWithTyped<bool?>();
    } else if (type == int) {
      return copyWithTyped<int?>();
    } else if (type == double) {
      return copyWithTyped<double?>();
    } else if (type == String) {
      return copyWithTyped<String?>();
    } else if (type == Uint8List) {
      return copyWithTyped<Uint8List?>();
    } else if (type == Int32List) {
      return copyWithTyped<Int32List?>();
    } else if (type == Int64List) {
      return copyWithTyped<Int64List?>();
    } else if (type == Float32List) {
      return copyWithTyped<Float32List?>();
    } else if (type == Float64List) {
      return copyWithTyped<Float64List?>();
    } else if (type == List) {
      return copyWithTyped<List?>();
    } else {
      return this;
    }
  }
}
