import 'dart:convert';

import 'package:equatable/equatable.dart';

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
  // ignore: prefer_const_constructors_in_immutables
  MicroAppEvent(
      {required this.name,
      this.payload,
      List<String> channels = const [],
      this.distinct = true})
      : super(channels);

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
      return jsonEncode(toMap());
    } catch (e) {
      return super.toString();
    }
  }

  /// [MicroAppEvent.fromJson(json)]
  static MicroAppEvent? fromJson(String json) {
    try {
      final map = jsonDecode(json);
      final name = map['name'];
      final payload = map['payload'];
      List<dynamic>? list = map['channels'];
      final channels =
          list != null ? list.map((e) => e.toString()).toList() : <String>[];
      return MicroAppEvent(name: name, payload: payload, channels: channels);
    } catch (e) {
      return null;
    }
  }

  /// [toMap]
  Map<String, dynamic> toMap() =>
      {'name': name, 'payload': payload, 'channels': channels};

  /// [MicroAppEvent.copyWith]
  MicroAppEvent<T> copyWith({
    String? name,
    T? payload,
    List<String>? channels,
  }) {
    return MicroAppEvent<T>(
        name: name ?? this.name,
        payload: payload ?? this.payload,
        channels: channels ?? this.channels);
  }

  String get type => payload.runtimeType.toString();

  @override
  List<Object?> get props => [name, payload, channels];
}
