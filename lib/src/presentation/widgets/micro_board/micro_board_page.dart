import 'package:flutter/material.dart';

import '../../../controllers/app_event/generic_micro_app_event_controller.dart';
import '../../../entities/micro_board/micro_board_app.dart';
import '../../../entities/micro_board/micro_board_handler.dart';
import 'micro_board_card_handler.dart';
import 'micro_board_card_webview_controllers.dart';
import 'micro_board_ma_widget.dart';

class MicroBoardPage extends StatefulWidget {
  final List<MicroBoardApp> apps;
  final List<MicroBoardHandler> orphanHandlers;
  final List<MicroBoardHandler> widgetHandlers;
  final List<String> conflictingChannels;
  final List<GenericMicroAppEventController> webviewControllers;
  const MicroBoardPage(
      {required this.apps,
      required this.orphanHandlers,
      required this.widgetHandlers,
      required this.webviewControllers,
      this.conflictingChannels = const <String>[],
      super.key});

  @override
  State<MicroBoardPage> createState() => _MicroBoardPageState();
}

class _MicroBoardPageState extends State<MicroBoardPage> {
  @override
  Widget build(BuildContext context) {
    int routesCount = 0;
    int microAppHandlerCount = 0;

    for (var app in widget.apps) {
      routesCount += app.pages.length;
      microAppHandlerCount += app.handlers.length;
    }

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 140,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.apps.length} Micro App(s)'),
              Text(
                  '${widget.conflictingChannels.length} Conflicting Channel(s)'),
              Text('$routesCount Micro Route(s)'),
              Text(
                  '${widget.widgetHandlers.length + widget.orphanHandlers.length + microAppHandlerCount} Event Handler(s)'),
              Text('${widget.webviewControllers.length} Webview Controller(s)'),
            ],
          )),
      body: Container(
        color: Colors.amber,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            ...widget.apps.map((e) => MicroBoardItemWidget(
                  e,
                  conflictingChannels: widget.conflictingChannels,
                )),
            MicroBoardHandlerCard(
                widgetHandlers: widget.widgetHandlers,
                title: 'Widget Handlers',
                conflictingChannels: widget.conflictingChannels),
            MicroBoardHandlerCard(
                widgetHandlers: widget.orphanHandlers,
                title: 'Orphan Handlers',
                conflictingChannels: widget.conflictingChannels,
                titleColor: Colors.red),
            MicroBoardWebviewControllersCard(
              title: 'Webview Controllers',
              webviewControllers: widget.webviewControllers,
            ),
            SizedBox(height: 54)
          ],
        ),
      ),
    );
  }
}
