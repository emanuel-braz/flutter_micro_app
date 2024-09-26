import 'dart:async';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../../controllers/fma_controller.dart';
import '../../helpers/excel_helper.dart';
import 'event_dispatcher_page.dart';
import 'micro_app_list_page.dart';
import 'micro_board/micro_board_page.dart';

class MainAppWidget extends StatefulWidget {
  const MainAppWidget({super.key});

  @override
  State createState() => _MainAppWidgetState();
}

class _MainAppWidgetState extends State<MainAppWidget> {
  int _currentIndex = 0;
  late List<Widget> _bars;
  late final StreamSubscription _onDashboardDataChangedSubscription;

  @override
  void dispose() {
    super.dispose();
    _onDashboardDataChangedSubscription.cancel();
  }

  @override
  void initState() {
    _bars = [
      const MicroBoardPage(),
      const MicroAppList(),
      const EventDispatcher(),
    ];

    _onDashboardDataChangedSubscription =
        serviceManager.service!.onExtensionEvent.listen((event) {
      if (event.extensionKind ==
          Constants.extensionToDevtoolsMicroBoardChanged) {
        _onDashboardDataChanged();
      }
    });

    super.initState();
  }

  void _onDashboardDataChanged() {
    FmaController().updateView().then((value) => setState(() {}));

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Micro Board Updated!'),
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Micro App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                FmaController().updateView().then((value) => setState(() {}));
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                ExcelHelper().create();
              },
              icon: const Icon(Icons.file_download_rounded),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Micro Board'),
                  onTap: () => _onItemTapped(0),
                ),
                ListTile(
                  leading: const Icon(Icons.import_contacts),
                  title: const Text('Micro Pages'),
                  onTap: () => _onItemTapped(1),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Event Dispatcher'),
                  onTap: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _bars,
            ),
          ),
        ],
      ),
    );
  }
}
