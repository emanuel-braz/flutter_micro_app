import 'dart:async';

import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../../controllers/fma_controller.dart';
import '../../helpers/excel_helper.dart';
import '../widgets/custom_drawer.dart';
import 'event_dispatcher_page.dart';
import 'micro_app_list_page.dart';
import 'micro_board/micro_board_page.dart';
import 'remote_config_page.dart';

class MainAppWidget extends StatefulWidget {
  const MainAppWidget({super.key});

  @override
  State createState() => _MainAppWidgetState();
}

class _MainAppWidgetState extends State<MainAppWidget> {
  int _currentIndex = 0;
  late List<Widget> _bars;
  late final StreamSubscription _onDashboardDataChangedSubscription;
  late final StreamSubscription _onInitRemoteConfigSubscription;

  @override
  void dispose() {
    super.dispose();
    _onDashboardDataChangedSubscription.cancel();
    _onInitRemoteConfigSubscription.cancel();
  }

  @override
  void initState() {
    _bars = [
      const MicroBoardPage(),
      const MicroAppList(),
      const EventDispatcher(),
      const RemoteConfigPage(),
    ];

    _onDashboardDataChangedSubscription =
        serviceManager.service!.onExtensionEvent.listen((event) {
      if (event.extensionKind ==
          Constants.extensionToDevtoolsMicroBoardChanged) {
        _onDashboardDataChanged();
      }
    });

    _onInitRemoteConfigSubscription =
        serviceManager.service!.onExtensionEvent.listen((event) {
      if (event.extensionKind ==
          Constants.notifyAppRemoteConfigDataHasChanged) {
        _onAppConfigHasChanged(event);
      }
    });

    Logger.interceptors.clear();
    Logger.interceptors.add(DefaultLogInterceptor(
      (Object? data) {
        extensionManager.postMessageToDevTools(
          ShowNotificationExtensionEvent(
            message: data.toString(),
          ),
        );
      },
    ));

    super.initState();
  }

  void _onAppConfigHasChanged(event) {
    l.d('Sync Remote Config');
    FmaController().syncRemoteConfigData();
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
      key: FmaController().scaffoldKey,
      appBar: AppBar(
        title: const Text('Flutter Micro App'),
        actions: [
          ListenableBuilder(
              listenable: extensionManager.darkThemeEnabled,
              builder: (context, child) {
                final isDarkThemeEnabled =
                    extensionManager.darkThemeEnabled.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      extensionManager.darkThemeEnabled.value =
                          !extensionManager.darkThemeEnabled.value;
                    },
                    icon: isDarkThemeEnabled
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
                  ),
                );
              }),
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
          CustomDrawer(
            onTap: (index) {
              _onItemTapped(index);
            },
            settingsDivider: false,
            widthSwitch: 700,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            sidebarItems: [
              CustomDrawerItem(
                iconSelected: Icons.dashboard,
                text: 'Micro Board',
              ),
              CustomDrawerItem(
                iconSelected: Icons.import_contacts,
                text: 'Micro Pages',
              ),
              CustomDrawerItem(
                iconSelected: Icons.send_time_extension,
                text: 'Event Dispatcher',
              ),
              CustomDrawerItem(
                iconSelected: Icons.settings_remote,
                text: 'Remote Config',
              ),
            ],
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
