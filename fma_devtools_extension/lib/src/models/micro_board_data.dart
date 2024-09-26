import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../ui/pages/micro_board/micro_board_util.dart';
import 'micro_board_webview.dart';

class MicroBoardData {
  final List<MicroBoardApp> microApps;
  final List<MicroBoardHandler> orphanHandlers;
  final List<MicroBoardHandler> widgetHandlers;
  final List<String> conflictingChannels;
  final List<MicroBoardWebview> webviewControllers;

  MicroBoardData({
    required this.microApps,
    required this.orphanHandlers,
    required this.widgetHandlers,
    required this.conflictingChannels,
    required this.webviewControllers,
  });

  factory MicroBoardData.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return MicroBoardData(
        microApps: [],
        orphanHandlers: [],
        widgetHandlers: [],
        conflictingChannels: [],
        webviewControllers: [],
      );
    }

    final apps = (map['micro_apps'] as List? ?? [])
        .map((e) => MicroBoardApp.fromMap(e))
        .toList();

    final orphans = (map['orphan_event_handlers'] as List? ?? [])
        .map((e) => MicroBoardHandler.fromMap(e))
        .toList();

    final widgets = (map['widget_event_handlers'] as List? ?? [])
        .map((e) => MicroBoardHandler.fromMap(e))
        .toList();

    final webviews = (map['webview_controllers'] as List? ?? [])
        .map((e) => MicroBoardWebview.fromMap(e))
        .toList();

    return MicroBoardData(
      microApps: apps,
      orphanHandlers: orphans,
      widgetHandlers: widgets,
      webviewControllers: webviews,
      conflictingChannels: MicroBoardUtil.getConflictChannels(
        apps,
        orphans,
        widgets,
      ),
    );
  }
}
