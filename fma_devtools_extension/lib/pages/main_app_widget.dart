import 'package:flutter/material.dart';

import '../src/models/micro_board_app.dart';
import 'event_dispatcher_page.dart';
import 'micro_app_list_page.dart';

class MainAppWidget extends StatefulWidget {
  final List<MicroBoardApp> microApps;
  final void Function()? updateView;

  const MainAppWidget(
      {super.key, required this.microApps, required this.updateView});

  @override
  State createState() => _MainAppWidgetState();
}

class _MainAppWidgetState extends State<MainAppWidget> {
  int _currentIndex = 0;

  late final List<Widget> _bars;

  @override
  void initState() {
    _bars = [
      MicroAppList(
        microApps: widget.microApps,
        updateView: widget.updateView,
      ),
      const EventDispatcher(),
    ];

    // TODO: Not compatible with Flutter stable version yet
    // TODO: Implement this - It receives events from the app to update micro board on app data changes
    // registerExtension(
    //     'ext.dev.emanuelbraz.fma.extensionToDevtoolsMicroBoardChanged',
    //     (method, parameters) async {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Micro Board Updated!'),
    //   ));

    //   return ServiceExtensionResponse.result('');
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bars[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            label: 'Micro Pages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Event Dispatcher',
          ),
        ],
      ),
    );
  }
}