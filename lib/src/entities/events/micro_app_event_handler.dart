import '../../../flutter_micro_app.dart';

/// [MicroAppEventHandler]
@pragma('vm:entry-point')
class MicroAppEventHandler<T> extends EventChannelsEquatable {
  final String? id;
  final MicroAppEventOnEvent onEvent;
  final MicroAppEventOnDone? onDone;
  final MicroAppEventOnError? onError;
  final bool? cancelOnError;
  final bool distinct;
  final String? parentName;

  const MicroAppEventHandler(this.onEvent,
      {this.onDone,
      this.onError,
      this.cancelOnError,
      List<String> channels = const [],
      this.id,
      this.distinct = true,
      this.parentName})
      : super(channels);

  @override
  List<Object?> get props =>
      [onEvent, onDone, onError, cancelOnError, channels, id, distinct];

  MicroAppEventHandler<R> copyWith<R>(
      {String? id,
      MicroAppEventOnEvent? onEvent,
      MicroAppEventOnDone? onDone,
      MicroAppEventOnError? onError,
      bool? cancelOnError,
      bool? distinct,
      String? parentName,
      List<String>? channels}) {
    final eventHandlerCopied = MicroAppEventHandler<R>(
      onEvent ?? this.onEvent,
      id: id ?? this.id,
      onDone: onDone ?? this.onDone,
      onError: onError ?? this.onError,
      cancelOnError: cancelOnError ?? this.cancelOnError,
      distinct: distinct ?? this.distinct,
      parentName: parentName ?? this.parentName,
      channels: channels ?? this.channels,
    );
    return eventHandlerCopied;
  }
}
