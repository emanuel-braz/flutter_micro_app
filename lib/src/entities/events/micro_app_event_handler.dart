import '../../../flutter_micro_app.dart';

/// [MicroAppEventHandler]
class MicroAppEventHandler<T> extends EventChannelsEquatable {
  final String? id;
  final MicroAppEventOnEvent onEvent;
  final MicroAppEventOnDone? onDone;
  final MicroAppEventOnError? onError;
  final bool? cancelOnError;
  final bool distinct;

  const MicroAppEventHandler(this.onEvent,
      {this.onDone,
      this.onError,
      this.cancelOnError,
      List<String> channels = const [],
      this.id,
      this.distinct = true})
      : super(channels);

  @override
  List<Object?> get props =>
      [onEvent, onDone, onError, cancelOnError, channels, id, distinct];
}
