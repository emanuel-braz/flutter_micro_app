import 'dart:developer';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'pages/main_app_widget.dart';
import 'src/models/micro_board_app.dart';

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
    final microApps = (microBoardData?['micro_apps'] as List? ?? [])
        .map((e) => MicroBoardApp.fromMap(e))
        .toList();

    return DevToolsExtension(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Micro App'),
              elevation: 0.9,
              actions: [
                IconButton(
                    onPressed: _updateView, icon: const Icon(Icons.refresh)),
              ],
            ),
            body: microBoardData == null
                ? const Center(child: CircularProgressIndicator())
                : MainAppWidget(
                    microApps: microApps,
                    updateView: _updateView,
                  )));
  }
}
