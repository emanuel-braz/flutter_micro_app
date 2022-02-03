// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/src/utils/enums/navigator_status.dart';
import 'package:flutter_micro_app/src/utils/typedefs.dart';

import 'navigator_event_controller.dart';

/// instance hidden
MicroAppNavigatorController? _navigatorInstance;

/// Global instance (can be accessed from any micro app)
MicroAppNavigatorController get NavigatorInstance {
  _navigatorInstance ??=
      MicroAppNavigatorController(MicroAppNavigatorEventController());
  return _navigatorInstance as MicroAppNavigatorController;
}

/// [MicroAppNavigatorController]
class MicroAppNavigatorController extends RouteObserver<PageRoute<dynamic>> {
  final MicroAppNavigatorEventController eventController;

  MicroAppNavigatorController(this.eventController) {
    _navigatorInstance = this;
  }

  /// [navigatorKey]
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// [NavigatorState]
  NavigatorState get nav => navigatorKey.currentState as NavigatorState;

  /// [pushNamedNative]
  Future<T?> pushNamedNative<T>(String routeName,
      {Object? arguments, String? type}) {
    eventController.logNavigationEvent(routeName,
        arguments: arguments,
        type: type ?? MicroAppNavigationType.pushNamedNative.name);
    return eventController.pushNamedNative(routeName,
        arguments: arguments, type: type);
  }

  /// [pushNamed]
  Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments, String? type}) {
    eventController.logNavigationEvent(routeName,
        arguments: arguments,
        type: type ?? MicroAppNavigationType.pushNamed.name);
    return nav.pushNamed(routeName, arguments: arguments);
  }

  /// [pushReplacementNamed]
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName,
      {TO? result,
      Object? arguments,
      String? type}) {
    eventController.logNavigationEvent(routeName,
        arguments: arguments,
        type: type ?? MicroAppNavigationType.pushReplacementNamed.name);
    return nav.pushReplacementNamed(routeName,
        arguments: arguments, result: result);
  }

  /// [push]
  Future<T?> push<T extends Object?>(Route<T> route, String? type) {
    eventController.logNavigationEvent(route.settings.name,
        arguments: route.settings.arguments,
        type: type ?? MicroAppNavigationType.push.name);
    return nav.push(route);
  }

  /// [pop]
  void pop<T extends Object?>([T? result, String? type]) {
    eventController.logNavigationEvent(null,
        type: type ?? MicroAppNavigationType.pop.name,
        arguments: result?.toString());
    return nav.pop(result);
  }

  /// [popAndPushNamed]
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
      String routeName,
      {TO? result,
      Object? arguments,
      String? type}) {
    eventController.logNavigationEvent(routeName,
        arguments: arguments,
        type: type ?? MicroAppNavigationType.popAndPushNamed.name);
    return nav.popAndPushNamed(routeName, arguments: arguments, result: result);
  }

  /// [pushNamedAndRemoveUntil]
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String newRouteName, RoutePredicate predicate,
      {Object? arguments, String? type}) {
    eventController.logNavigationEvent(newRouteName,
        arguments: arguments,
        type: type ?? MicroAppNavigationType.pushNamedAndRemoveUntil.name);
    return nav.pushNamedAndRemoveUntil(newRouteName, predicate,
        arguments: arguments);
  }

  /// [popUntil]
  void popUntil(RoutePredicate predicate, {String? type}) {
    eventController.logNavigationEvent(null,
        type: type ?? MicroAppNavigationType.popUntil.name);
    nav.popUntil(predicate);
  }

  /// [getPageRoute]
  MaterialPageRoute? getPageRoute(
      RouteSettings settings, Map<String, PageBuilder> routes,
      {bool? routeNativeOnError}) {
    final routeName = settings.name;
    final routeArguments = settings.arguments;
    final pageBuilder = routes[routeName];

    if (pageBuilder == null) {
      if (routeName != null && (routeNativeOnError ?? false)) {
        pushNamedNative(routeName, arguments: routeArguments);
      }
      return null;
    }

    return MaterialPageRoute(
      builder: (context) => pageBuilder(context, routeArguments),
    );
  }

  /// [didPush]
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    eventController.logNavigationEvent(route.settings.name,
        type: MicroAppNavigationType.didPush.name);
  }

  /// [didReplace]
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    eventController.logNavigationEvent(newRoute?.settings.name,
        type: MicroAppNavigationType.didReplace.name);
  }

  /// [didPop]
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    eventController.logNavigationEvent(previousRoute?.settings.name,
        type: MicroAppNavigationType.didPop.name);
  }
}
