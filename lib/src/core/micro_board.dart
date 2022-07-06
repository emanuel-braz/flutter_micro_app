import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

const _notTyped = 'Not Typed';

class MicroBoard {
  List<MicroBoardApp> get getMicroBoardApps {
    if (MicroHost.microApps.isNotEmpty) {
      final microBoardApps = MicroHost.microApps.map((currentMicroApp) {
        String microAppRoute = '';
        String microPageRoute = '';

        if (currentMicroApp is MicroAppWithBaseRoute) {
          microAppRoute = currentMicroApp.baseRoute.baseRoute.route;
        } else if (currentMicroApp is IMicroAppBaseRoute) {
          microAppRoute =
              (currentMicroApp as IMicroAppBaseRoute).baseRoute.route;
        }

        final routes = currentMicroApp.pages.map((e) {
          if (e.route.isNotEmpty) {
            final splited =
                e.route.split(MicroAppPreferences.config.pathSeparator);

            if (splited.isNotEmpty) {
              // If there is no baseRoute, infer the baseroute if all routes have the first segment identical
              if (microAppRoute.isEmpty &&
                  currentMicroApp.pages.every(
                      (element) => element.route.startsWith(splited.first))) {
                microAppRoute = splited.first;
              }

              if (splited.length > 1) {
                splited.removeAt(0);
                microPageRoute =
                    splited.join(MicroAppPreferences.config.pathSeparator);
              } else {
                microPageRoute = splited.first;
              }
            }
          }

          String widget = e.pageBuilder.runtimeType.toString();
          if (widget == 'PageBuilder<Widget>') {
            widget = '';
          } else {
            widget = widget.replaceFirst('PageBuilder<', '');
            widget = widget.replaceFirst('>', '', widget.lastIndexOf('>'));
          }

          return MicroBoardRoute(route: microPageRoute, widget: widget);
        }).toList();

        final handlers = MicroAppEventController()
            .handlers
            .entries
            .where((element) => element.key.parentName == currentMicroApp.name)
            .map((entry) {
          String handlerType = entry.key.runtimeType.toString();
          if (handlerType == 'MicroAppEventHandler<dynamic>') {
            handlerType = _notTyped;
          } else {
            handlerType = handlerType.replaceFirst('MicroAppEventHandler', '');
          }

          return MicroBoardHandler(
              type: handlerType, channels: entry.key.channels);
        }).toList();

        return MicroBoardApp(
          type: currentMicroApp.runtimeType.toString(),
          name: currentMicroApp.name,
          route: microAppRoute,
          pages: routes,
          handlers: handlers,
        );
      }).toList();

      return microBoardApps;
    }

    return [];
  }

  List<MicroBoardHandler> getOrphanHandlers() {
    return MicroAppEventController()
        .handlers
        .entries
        .where((element) => element.key.parentName?.isEmpty ?? true)
        .map((entry) {
      String handlerType = entry.key.runtimeType.toString();
      if (handlerType == 'MicroAppEventHandler<dynamic>') {
        handlerType = 'Not Typed';
      } else {
        handlerType = handlerType.replaceFirst('MicroAppEventHandler', '');
      }

      return MicroBoardHandler(type: handlerType, channels: entry.key.channels);
    }).toList();
  }

  List<MicroBoardHandler> getWidgetsHandlers() {
    return MicroAppEventController()
        .handlers
        .entries
        .where((element) => !MicroHost.microApps
            .map((e) => e.name)
            .contains(element.key.parentName))
        .where((element) => element.key.parentName?.isNotEmpty == true)
        .map((entry) {
      String handlerType = entry.key.runtimeType.toString();
      if (handlerType == 'MicroAppEventHandler<dynamic>') {
        handlerType = 'Not Typed';
      } else {
        handlerType = handlerType.replaceFirst('MicroAppEventHandler', '');
        handlerType = '<${entry.key.parentName}$handlerType>';
      }

      return MicroBoardHandler(type: handlerType, channels: entry.key.channels);
    }).toList();
  }

  void show() {
    final apps = MicroBoard().getMicroBoardApps;
    final orphanHandlers = getOrphanHandlers();
    final widgetHandlers = getWidgetsHandlers();

    NavigatorInstance.push(MaterialPageRoute(
        builder: (context) =>
            MicroBoardWidget(apps, orphanHandlers, widgetHandlers)));
  }

  MicroBoard();
}

class MicroBoardApp {
  final String type;
  final String name;
  final String route;
  final List<MicroBoardRoute> pages;
  final List<MicroBoardHandler> handlers;

  MicroBoardApp({
    required this.type,
    required this.name,
    required this.route,
    required this.pages,
    required this.handlers,
  });
}

class MicroBoardRoute {
  final String route;
  final String widget;

  MicroBoardRoute({
    required this.route,
    required this.widget,
  });
}

class MicroBoardHandler {
  final String type;
  final List<String> channels;

  MicroBoardHandler({
    required this.type,
    required this.channels,
  });
}

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
            WidgetsHandlers(
              widgetHandlers: widget.widgetHandlers,
              title: 'Widget Handlers',
            ),
            WidgetsHandlers(
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

class MicroBoardItemWidget extends StatelessWidget {
  final MicroBoardApp app;
  const MicroBoardItemWidget(this.app, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                app.name,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '<${app.type}>',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Card(
              margin: EdgeInsets.all(4),
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text('Base Route:', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 4),
                        Chip(
                          label: Text(app.route),
                          backgroundColor: Colors.blueGrey[200],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Wrap(
                      spacing: 4,
                      runSpacing: 0,
                      children: app.pages
                          .map((e) => Chip(
                              backgroundColor: Colors.blueGrey[350],
                              label: Text(
                                  '/${e.route}${e.widget.isNotEmpty ? "<${e.widget}>" : ""}')))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(4),
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child:
                              Text('Handlers', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    ...app.handlers
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                    shadowColor: Colors.blue[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Chip(
                                            label: Text(e.type),
                                            backgroundColor: e.type == _notTyped
                                                ? Colors.amber
                                                : Colors.blue[200],
                                          ),
                                          Wrap(
                                            spacing: 4,
                                            runSpacing: 0,
                                            children: e.channels
                                                .map((e) => Chip(
                                                    label: Text(e),
                                                    backgroundColor:
                                                        Colors.green[200]))
                                                .toList(),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetsHandlers extends StatelessWidget {
  final List<MicroBoardHandler> widgetHandlers;
  final String title;
  final Color? titleColor;
  const WidgetsHandlers(
      {required this.widgetHandlers,
      required this.title,
      this.titleColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(title,
                      style: TextStyle(fontSize: 18, color: titleColor)),
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            ...widgetHandlers
                .map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                            shadowColor: Colors.blue[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(e.type),
                                    backgroundColor: e.type == _notTyped
                                        ? Colors.amber
                                        : Colors.blue[200],
                                  ),
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 0,
                                    children: e.channels
                                        .map((e) => Chip(
                                              label: Text(e),
                                              backgroundColor:
                                                  Colors.green[200],
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
