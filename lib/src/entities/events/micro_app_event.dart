import 'dart:async';
import 'dart:convert';

import 'package:dart_log/dart_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

/// Event channels
abstract class EventChannelsEquatable extends Equatable {
  final List<String> channels;
  const EventChannelsEquatable(this.channels);
}

/// [MicroAppEvent]
class MicroAppEvent<T> extends EventChannelsEquatable {
  final String name;
  final T? payload;
  final bool distinct;
  final MethodCall? methodCall;
  final String? version;
  final DateTime timestamp;
  final Completer _completer = Completer();

  MicroAppEvent({
    List<String> channels = const [],
    DateTime? timestamp,
    required this.name,
    this.payload,
    this.distinct = true,
    this.methodCall,
    this.version,
  })  : timestamp = timestamp ?? DateTime.now(),
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
        'payload': payload,
        'channels': channels,
        'distinct': distinct,
        'methodCall': methodCall.toString(),
        'version': version,
        'timestamp': timestamp.toIso8601String()
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
    DateTime? timestamp,
  }) {
    return MicroAppEvent<T>(
        name: name ?? this.name,
        payload: payload ?? this.payload,
        distinct: distinct ?? this.distinct,
        methodCall: methodCall ?? this.methodCall,
        version: version ?? this.version,
        timestamp: timestamp ?? this.timestamp,
        channels: channels);
  }

  Type get type => payload.runtimeType;

  /// Completes with success
  void resultSuccess([FutureOr<dynamic>? value]) => _completer.complete(value);

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
      'payload': payload,
      'channels': channels,
      'distinct': distinct,
      'version': version,
      'timestamp': timestamp.toIso8601String(),
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
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      channels: channels,
    );
  }

  String toJson() => json.encode(toMap());

  static MicroAppEvent? fromJson(String source) {
    try {
      return MicroAppEvent.fromMap(json.decode(source));
    } catch (e) {
      logger.e('[MicroAppEvent]: error parsing json', error: e);
      return null;
    }
  }
}
