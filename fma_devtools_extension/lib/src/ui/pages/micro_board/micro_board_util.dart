import 'package:flutter_micro_app/flutter_micro_app.dart';

class MicroBoardUtil {
  static List<String> getConflictChannels(
    List<MicroBoardApp> microApps,
    List<MicroBoardHandler> orphanHandlers,
    List<MicroBoardHandler> widgetHandlers,
  ) {
    var conflictingChannels = <String>[];

    for (var app in microApps) {
      for (MicroBoardHandler handler in app.handlers) {
        conflictingChannels.addAll(handler.channels);
      }
    }

    for (var handler in orphanHandlers) {
      conflictingChannels.addAll(handler.channels);
    }

    for (var handler in widgetHandlers) {
      conflictingChannels.addAll(handler.channels);
    }

    conflictingChannels = conflictingChannels
        .where((filter) =>
            conflictingChannels.where((element) => element == filter).length >
            1)
        .toSet()
        .toList();

    return conflictingChannels;
  }
}
