import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../flutter_micro_app.dart';
import '../entities/micro_board/micro_board_app.dart';
import '../entities/micro_board/micro_board_handler.dart';
import '../entities/micro_board/micro_board_route.dart';
import '../presentation/widgets/micro_board/micro_board_page.dart';

class MicroBoard {
  late MicroAppEventController microAppEventController;

  MicroBoard({MicroAppEventController? microAppEventController})
      : microAppEventController =
            microAppEventController ?? MicroAppEventController();

  List<MicroBoardApp> get getMicroBoardApps {
    if (MicroHost.microApps.isNotEmpty) {
      final microBoardApps = MicroHost.microApps.map((currentMicroApp) {
        String microAppRoute = '';
        String microPageRoute = '';
        String parentName = '';

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

              microPageRoute = e.route;
            }
          }

          parentName = e.pageBuilder.runtimeType.toString();
          if (parentName == 'PageBuilder<Widget>') {
            parentName = '';
          } else {
            parentName = parentName.replaceFirst('PageBuilder<', '');
            parentName =
                parentName.replaceFirst('>', '', parentName.lastIndexOf('>'));
          }

          return MicroBoardRoute(
              route: microPageRoute,
              widget: parentName,
              description: e.description);
        }).toList();

        final handlers = microAppEventController.handlers.entries
            .where((element) => element.key.parentName == currentMicroApp.name)
            .map((entry) {
          String handlerType = entry.key.runtimeType.toString();
          if (handlerType == 'MicroAppEventHandler<dynamic>') {
            handlerType = Constants.notTyped;
          } else {
            handlerType = handlerType.replaceFirst('MicroAppEventHandler', '');
          }

          return MicroBoardHandler(
              type: handlerType,
              channels: entry.key.channels,
              parentName: parentName);
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
    return microAppEventController.handlers.entries
        .where((element) => element.key.parentName?.isEmpty ?? true)
        .map((entry) {
      String handlerType = entry.key.runtimeType.toString();
      if (handlerType == 'MicroAppEventHandler<dynamic>') {
        handlerType = 'Not Typed';
      } else {
        handlerType = handlerType.replaceFirst('MicroAppEventHandler', '');
      }

      return MicroBoardHandler(
          type: handlerType,
          channels: entry.key.channels,
          parentName: entry.key.parentName ?? '');
    }).toList();
  }

  List<MicroBoardHandler> getWidgetsHandlers() {
    return microAppEventController.handlers.entries
        .where((element) => !MicroHost.microApps
            .map((e) => e.name)
            .contains(element.key.parentName))
        .where((element) => element.key.parentName?.isNotEmpty == true)
        .map((entry) {
      String parentName = entry.key.parentName ?? '';
      String handlerType = entry.key.runtimeType.toString();
      if (handlerType == 'MicroAppEventHandler<dynamic>') {
        handlerType = 'Not Typed';
      } else {
        handlerType = handlerType.replaceFirst('MicroAppEventHandler', '');
      }

      return MicroBoardHandler(
          type: handlerType,
          channels: entry.key.channels,
          parentName: parentName);
    }).toList();
  }

  List<GenericMicroAppEventController> getWebviewControllers() {
    return microAppEventController.webviewControllers.values.map((controller) {
      controller.parentName ??= 'Widget';
      return controller;
    }).toList();
  }

  void showBoard() {
    if (NavigatorInstance.navigatorKey.currentState == null) return;

    final apps = MicroBoard().getMicroBoardApps;

    final orphanHandlers = getOrphanHandlers();
    final widgetHandlers = getWidgetsHandlers();
    final webviewControllers = getWebviewControllers();

    var conflictingChannels = <String>[];

    for (var app in apps) {
      for (var handler in app.handlers) {
        conflictingChannels.addAll(handler.channels);
      }
    }

    for (var handler in orphanHandlers) {
      conflictingChannels.addAll(handler.channels);
    }

    for (var handler in widgetHandlers) {
      conflictingChannels.addAll(handler.channels);
    }

    conflictingChannels = conflictingChannels
        .where((filter) =>
            conflictingChannels.where((element) => element == filter).length >
            1)
        .toSet()
        .toList();

    NavigatorInstance.push(
      MaterialPageRoute(
        builder: (context) => MicroBoardPage(
          apps: apps,
          orphanHandlers: orphanHandlers,
          widgetHandlers: widgetHandlers,
          conflictingChannels: conflictingChannels,
          webviewControllers: webviewControllers,
        ),
      ),
    );
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

  static showButton({bool forceInReleaseMode = false}) {
    if (kReleaseMode && !forceInReleaseMode) return;

    if (NavigatorInstance.navigatorKey.currentState == null) return;

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
}
