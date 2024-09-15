import 'package:flutter/material.dart';

import '../../src/models/micro_board_app.dart';
import '../../src/models/micro_board_handler.dart';
import '../../src/models/micro_board_route.dart';
import '../../src/models/micro_board_webview.dart';
import 'micro_board_card_handler.dart';
import 'micro_board_ma_widget.dart';

class MicroBoardPage extends StatefulWidget {
  final List<MicroBoardApp> apps;
  final List<MicroBoardHandler> orphanHandlers;
  final List<MicroBoardHandler> widgetHandlers;
  final List<String> conflictingChannels;
  final List<MicroBoardWebview> webviewControllers;
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
  final TextEditingController _filterInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    int routesCount = 0;
    int microAppHandlerCount = 0;

    for (var app in widget.apps) {
      final pages = app.pages;
      final handlers = app.handlers;

      if (pages != null) routesCount += pages.length;

      if (handlers != null) microAppHandlerCount += handlers.length;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Text('${widget.apps.length} Micro App(s)'),
                ),
                TableCell(
                  child: Text(
                      '${widget.conflictingChannels.length} Conflicting Channel(s)'),
                ),
                TableCell(
                  child: Text('$routesCount Micro Route(s)'),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Text(
                      '${widget.widgetHandlers.length + widget.orphanHandlers.length + microAppHandlerCount} Event Handler(s)'),
                ),
                TableCell(
                  child: Text(
                      '${widget.webviewControllers.length} Webview Controller(s)'),
                ),
                const TableCell(
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _filterInput,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                hintText: 'Search for a route',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                ...(List<MicroBoardApp>.from(widget.apps)).where((e) {
                  return e.pages!.any((p) {
                    return p.route
                            .toLowerCase()
                            .contains(_filterInput.text.toLowerCase()) ||
                        p.description
                            .toLowerCase()
                            .contains(_filterInput.text.toLowerCase());
                  });
                }).map((e) {
                  final filteredPages =
                      List<MicroBoardRoute>.from(e.pages ?? []);

                  filteredPages.removeWhere((p) =>
                      !p.route
                          .toLowerCase()
                          .contains(_filterInput.text.toLowerCase()) &&
                      !p.description
                          .toLowerCase()
                          .contains(_filterInput.text.toLowerCase()));

                  return MicroBoardItemWidget(
                    e.copyWith(pages: filteredPages),
                    conflictingChannels: widget.conflictingChannels,
                  );
                }),
                MicroBoardHandlerCard(
                  widgetHandlers: widget.widgetHandlers,
                  title: 'Widget Handlers',
                  conflictingChannels: widget.conflictingChannels,
                  titleColor: Colors.green,
                ),
                MicroBoardHandlerCard(
                    widgetHandlers: widget.orphanHandlers,
                    title: 'Orphan Handlers',
                    conflictingChannels: widget.conflictingChannels,
                    titleColor: Colors.red),
                const SizedBox(height: 54)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
