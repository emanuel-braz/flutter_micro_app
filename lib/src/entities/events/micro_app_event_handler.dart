import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../flutter_micro_app.dart';

/// [MicroAppEventHandler]
class MicroAppEventHandler<T> extends EventChannelsEquatable {
  final String? id;
  final MicroAppEventOnEvent onEvent;
  final MicroAppEventOnDone? onDone;
  final MicroAppEventOnError? onError;
  final bool? cancelOnError;
  final bool onlyDistinctEvents;
  final String? parentName;
  final int maxEventsHistory;
  final List<MicroAppEvent> _previous = [];

  MicroAppEvent? get lastEvent => _previous.firstOrNull;
  List<MicroAppEvent> get history => _previous;

  @visibleForTesting
  void setPrevious(MicroAppEvent event) {
    if (maxEventsHistory <= 0) return;
    if (_previous.length == maxEventsHistory) _previous.removeLast();
    _previous.insert(0, event);
  }

  MicroAppEventHandler(
    this.onEvent, {
    this.onDone,
    this.onError,
    this.cancelOnError,
    List<String> channels = const [],
    this.id,
    this.onlyDistinctEvents = true,
    this.parentName,
    this.maxEventsHistory = 1,
  }) : super(channels);

  @override
  List<Object?> get props => [
        onEvent,
        onDone,
        onError,
        cancelOnError,
        channels,
        id,
        onlyDistinctEvents,
        maxEventsHistory,
      ];

  MicroAppEventHandler<R> copyWith<R>({
    String? id,
    MicroAppEventOnEvent? onEvent,
    MicroAppEventOnDone? onDone,
    MicroAppEventOnError? onError,
    bool? cancelOnError,
    bool? onlyDistinctEvents,
    String? parentName,
    List<String>? channels,
    int? maxEventsHistory,
  }) {
    final eventHandlerCopied = MicroAppEventHandler<R>(
      onEvent ?? this.onEvent,
      id: id ?? this.id,
      onDone: onDone ?? this.onDone,
      onError: onError ?? this.onError,
      cancelOnError: cancelOnError ?? this.cancelOnError,
      onlyDistinctEvents: onlyDistinctEvents ?? this.onlyDistinctEvents,
      parentName: parentName ?? this.parentName,
      channels: channels ?? this.channels,
      maxEventsHistory: maxEventsHistory ?? this.maxEventsHistory,
    );
    return eventHandlerCopied;
  }
}
