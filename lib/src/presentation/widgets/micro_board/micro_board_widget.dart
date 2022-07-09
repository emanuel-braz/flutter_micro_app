import 'package:flutter/material.dart';
import 'package:flutter_micro_app/src/entities/micro_board/micro_board_app.dart';
import 'package:flutter_micro_app/src/entities/micro_board/micro_board_handler.dart';

import 'micro_board_handler_widget.dart';
import 'micro_board_item_widget.dart';

class MicroBoardWidget extends StatefulWidget {
  final List<MicroBoardApp> apps;
  final List<MicroBoardHandler> orphanHandlers;
  final List<MicroBoardHandler> widgetHandlers;
  const MicroBoardWidget(this.apps, this.orphanHandlers, this.widgetHandlers,
      {Key? key})
      : super(key: key);

  @override
  State<MicroBoardWidget> createState() => _MicroBoardWidgetState();
}

class _MicroBoardWidgetState extends State<MicroBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Micro Board'),
      ),
      body: Container(
        color: Colors.amber,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            ...widget.apps.map((e) => MicroBoardItemWidget(e)).toList(),
            HandlersWidget(
              widgetHandlers: widget.widgetHandlers,
              title: 'Widget Handlers',
            ),
            HandlersWidget(
                widgetHandlers: widget.orphanHandlers,
                title: 'Orphan Handlers',
                titleColor: Colors.red),
            SizedBox(
              height: 54,
            )
          ],
        ),
      ),
    );
  }
}
