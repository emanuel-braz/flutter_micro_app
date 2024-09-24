import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../../../models/micro_board_webview.dart';
import '../../widgets/circular_widget.dart';
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

      routesCount += pages.length;

      microAppHandlerCount += handlers.length;
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          toolbarHeight: 120,
          title: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularWidget(
                    title: '${widget.apps.length}',
                    description: 'Micro App(s)'),
                CircularWidget(
                    title: '$routesCount', description: 'Micro Route(s)'),
                CircularWidget(
                    title: widget.conflictingChannels.length.toString(),
                    description: 'Conflicting Channel(s)',
                    borderColor: widget.conflictingChannels.isNotEmpty
                        ? Colors.red
                        : Colors.green),
                CircularWidget(
                    title:
                        '${widget.widgetHandlers.length + widget.orphanHandlers.length + microAppHandlerCount}',
                    description: 'Event Handler(s)'),
                CircularWidget(
                    title: '${widget.webviewControllers.length} ',
                    description: 'Webview Controller(s)'),
              ],
            ),
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _filterInput,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for a route',
                hintText: 'route path or description',
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
                  return e.pages.any((p) {
                    return p.route
                            .toLowerCase()
                            .contains(_filterInput.text.toLowerCase()) ||
                        p.description
                            .toLowerCase()
                            .contains(_filterInput.text.toLowerCase());
                  });
                }).map((e) {
                  final filteredPages = List<MicroBoardRoute>.from(e.pages);

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
