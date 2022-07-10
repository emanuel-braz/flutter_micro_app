import 'package:flutter/material.dart';

import '../../../entities/micro_board/micro_board_app.dart';
import '../../../entities/micro_board/micro_board_handler.dart';
import 'micro_board_card_handler.dart';
import 'micro_board_ma_widget.dart';

class MicroBoardPage extends StatefulWidget {
  final List<MicroBoardApp> apps;
  final List<MicroBoardHandler> orphanHandlers;
  final List<MicroBoardHandler> widgetHandlers;
  final List<String> conflictingChannels;
  const MicroBoardPage(
      {required this.apps,
      required this.orphanHandlers,
      required this.widgetHandlers,
      this.conflictingChannels = const <String>[],
      Key? key})
      : super(key: key);

  @override
  State<MicroBoardPage> createState() => _MicroBoardPageState();
}

class _MicroBoardPageState extends State<MicroBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.apps.length} Micro App(s)'),
      ),
      body: Container(
        color: Colors.amber,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            ...widget.apps
                .map((e) => MicroBoardItemWidget(
                      e,
                      conflictingChannels: widget.conflictingChannels,
                    ))
                .toList(),
            MicroBoardHandlerCard(
                widgetHandlers: widget.widgetHandlers,
                title: 'Widget Handlers',
                conflictingChannels: widget.conflictingChannels),
            MicroBoardHandlerCard(
                widgetHandlers: widget.orphanHandlers,
                title: 'Orphan Handlers',
                conflictingChannels: widget.conflictingChannels,
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
