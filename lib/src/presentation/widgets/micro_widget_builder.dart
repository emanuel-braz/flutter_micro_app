import 'package:flutter/widgets.dart';

import '../../../flutter_micro_app.dart';
import '../../controllers/app_event/micro_app_event_delegate.dart';

class MicroAppWidgetBuilder<T> extends StatefulWidget {
  const MicroAppWidgetBuilder({
    required this.builder,
    this.channels = const [],
    this.initialData,
    Key? key,
  }) : super(key: key);

  final MicroAppBuilder builder;
  final List<String> channels;
  final MicroAppEvent<T>? initialData;

  @override
  _MicroAppWidgetBuilderState<T> createState() =>
      _MicroAppWidgetBuilderState<T>();
}

class _MicroAppWidgetBuilderState<T> extends State<MicroAppWidgetBuilder> {
  Stream<MicroAppEvent>? stream;
  final helper = MicroAppEventDelegate();

  @override
  void initState() {
    super.initState();
    _updateStream();
  }

  @override
  void didUpdateWidget(MicroAppWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    final channelsChanged = !oldWidget.channels.equals(widget.channels);
    if (channelsChanged) {
      _updateStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: widget.initialData,
        stream: stream,
        builder: widget.builder);
  }

  _updateStream() {
    stream = MicroAppEventController().stream.distinct().where((event) {
      final isSameType = helper.handlerHasSameEventTypeOrDynamic(
          MicroAppEventHandler<T>((_) {}), event);
      final hasSomeChannels = helper.containsSomeChannelsOrHandlerHasNoChannels(
          widget.channels, event.channels);
      return isSameType && hasSomeChannels;
    });
  }
}
