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
          description: currentMicroApp.description,
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

  void showBoard() {
    final apps = MicroBoard().getMicroBoardApps;
    final orphanHandlers = getOrphanHandlers();
    final widgetHandlers = getWidgetsHandlers();

    NavigatorInstance.push(MaterialPageRoute(
        builder: (context) =>
            MicroBoardWidget(apps, orphanHandlers, widgetHandlers)));
  }

  static Offset? _buttonOverlayOffset;
  static OverlayEntry? _buttonOverlay;

  static final _floatButton = Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap: () {
            MicroBoard().showBoard();
          },
          onLongPress: hideButton,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.dashboard_outlined,
                color: Colors.white.withOpacity(.5),
                size: 30,
              )),
        ),
      ));

  static showButton() {
    Future.delayed(Duration.zero, () {
      try {
        final size = NavigatorInstance.navigatorKey.currentState?.context.size;
        final double width = size?.width ?? 200;
        final double height = size?.height ?? 250;

        _buttonOverlayOffset ??= Offset(width - 100, height - 100);

        _buttonOverlay ??= OverlayEntry(
          maintainState: true,
          opaque: false,
          builder: (context) {
            return Positioned(
                top: _buttonOverlayOffset!.dy,
                left: _buttonOverlayOffset!.dx,
                child: Draggable(
                  onDragEnd: (DraggableDetails detail) =>
                      _buttonOverlayOffset = detail.offset,
                  childWhenDragging: Container(),
                  child: _floatButton,
                  feedback: _floatButton,
                ));
          },
        );
        final overlay = NavigatorInstance.navigatorKey.currentState?.overlay;
        overlay?.insert(_buttonOverlay!);
      } catch (_) {}
    });
  }

  static hideButton() {
    _buttonOverlay?.remove();
  }

  MicroBoard();
}

class MicroBoardApp {
  final String type;
  final String name;
  final String description;
  final String route;
  final List<MicroBoardRoute> pages;
  final List<MicroBoardHandler> handlers;

  MicroBoardApp({
    required this.type,
    required this.name,
    required this.description,
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
            if (app.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  app.description,
                  style: TextStyle(fontSize: 14, color: Colors.white),
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

class HandlersWidget extends StatelessWidget {
  final List<MicroBoardHandler> widgetHandlers;
  final String title;
  final Color? titleColor;
  const HandlersWidget(
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
