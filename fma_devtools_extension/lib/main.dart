import 'dart:developer';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fma_devtools_extension/src/models/micro_board_webview.dart';

import 'pages/main_app_widget.dart';
import 'src/models/micro_board_app.dart';
import 'src/models/micro_board_handler.dart';

void main() {
  runApp(const FmaDevtoolsExtension());
}

class FmaDevtoolsExtension extends StatefulWidget {
  const FmaDevtoolsExtension({Key? key}) : super(key: key);

  @override
  State<FmaDevtoolsExtension> createState() => _FmaDevtoolsExtensionState();
}

class _FmaDevtoolsExtensionState extends State<FmaDevtoolsExtension> {
  Map<String, dynamic>? microBoardData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _updateView());
    super.initState();
  }

  Future<void> _updateView() async {
    try {
      final response = await serviceManager.callServiceExtensionOnMainIsolate(
          'ext.dev.emanuelbraz.fma.devtoolsToExtensionUpdate',
          args: {});

      setState(() {
        microBoardData = response.json;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final MicroBoardData microBoard = MicroBoardData.fromMap(microBoardData);

    return DevToolsExtension(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Flutter Micro App'),
              elevation: 0.9,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: _updateView,
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
            body: microBoardData == null
                ? const Center(child: CircularProgressIndicator())
                : MainAppWidget(
                    microBoardData: microBoard,
                    updateView: _updateView,
                  )));
  }
}

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

    return MicroBoardData(
      microApps: (map['micro_apps'] as List? ?? [])
          .map((e) => MicroBoardApp.fromMap(e))
          .toList(),
      orphanHandlers: (map['orphan_event_handlers'] as List? ?? [])
          .map((e) => MicroBoardHandler.fromMap(e))
          .toList(),
      widgetHandlers: (map['widget_event_handlers'] as List? ?? [])
          .map((e) => MicroBoardHandler.fromMap(e))
          .toList(),
      conflictingChannels: (map['conflicting_channels'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      webviewControllers: (map['webview_controllers'] as List? ?? [])
          .map((e) => MicroBoardWebview.fromMap(e))
          .toList(),
    );
  }
}
