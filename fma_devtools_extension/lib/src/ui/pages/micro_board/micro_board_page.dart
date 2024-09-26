import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../../../controllers/fma_controller.dart';
import '../../widgets/circular_stroke.dart';
import '../../widgets/circular_widget.dart';
import 'micro_board_card_handler.dart';
import 'micro_board_ma_widget.dart';

class MicroBoardPage extends StatefulWidget {
  const MicroBoardPage({super.key});

  @override
  State<MicroBoardPage> createState() => _MicroBoardPageState();
}

class _MicroBoardPageState extends State<MicroBoardPage> {
  final TextEditingController _filterInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FmaController(),
      builder: (context, value, child) {
        int routesCount = 0;
        int microAppHandlerCount = 0;

        for (var app in value.microBoardData.microApps) {
          final pages = app.pages;
          final handlers = app.handlers;
          routesCount += pages.length;
          microAppHandlerCount += handlers.length;
        }

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    CircularDashboard(
                      elements: value.microBoardData.microApps.map((e) {
                        return DashboardElement(
                            label: e.name, value: e.pages.length);
                      }).toList(),
                    ),
                    CircularWidget(
                        title: '$routesCount', description: 'Micro Route(s)'),
                    CircularWidget(
                        title:
                            '${value.microBoardData.widgetHandlers.length + value.microBoardData.orphanHandlers.length + microAppHandlerCount}',
                        description: 'Event Handler(s)'),
                    CircularWidget(
                        title: value.microBoardData.orphanHandlers.length
                            .toString(),
                        description: 'Orphan Handler(s)',
                        borderColor:
                            value.microBoardData.conflictingChannels.isNotEmpty
                                ? Colors.red
                                : Colors.green),
                    CircularWidget(
                        title: value.microBoardData.conflictingChannels.length
                            .toString(),
                        description: 'Conflicting Channel(s)',
                        borderColor:
                            value.microBoardData.conflictingChannels.isNotEmpty
                                ? Colors.red
                                : Colors.green),
                    CircularWidget(
                        title:
                            '${value.microBoardData.webviewControllers.length} ',
                        description: 'Webview Controller(s)'),
                  ]
                      .map(
                        (item) => Container(
                          alignment: Alignment.bottomCenter,
                          width: 160,
                          height: 100,
                          child: item,
                        ),
                      )
                      .toList()),
              const SizedBox(height: 8),
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
                    ...(List<MicroBoardApp>.from(
                            value.microBoardData.microApps))
                        .where((e) {
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
                        conflictingChannels:
                            value.microBoardData.conflictingChannels,
                      );
                    }),
                    MicroBoardHandlerCard(
                      widgetHandlers: value.microBoardData.widgetHandlers,
                      title: 'Widget Handlers',
                      conflictingChannels:
                          value.microBoardData.conflictingChannels,
                      titleColor: Colors.green,
                    ),
                    MicroBoardHandlerCard(
                        widgetHandlers: value.microBoardData.orphanHandlers,
                        title: 'Orphan Handlers',
                        conflictingChannels:
                            value.microBoardData.conflictingChannels,
                        titleColor: Colors.red),
                    const SizedBox(height: 54)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
