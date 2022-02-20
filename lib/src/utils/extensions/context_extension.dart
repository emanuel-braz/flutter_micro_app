import 'package:flutter/cupertino.dart';

import '../../../flutter_micro_app.dart';

extension MicroAppNavigatorContextExtension on BuildContext {
  Nav get maNav => Nav(this);
}

class Nav {
  final BuildContext context;
  Nav(this.context);

  /// [pushNamedNative]
  Future<T?> pushNamedNative<T>(String routeName, {Object? arguments}) =>
      NavigatorInstance.pushNamedNative(routeName, arguments: arguments);

  /// [getPageWidget]
  Widget getPageWidget(String routeName,
          {Object? arguments, String? type, Widget? orElse}) =>
      NavigatorInstance.getPageWidget(routeName, context,
          arguments: arguments, orElse: orElse, type: type);

  /// [pushNamed]
  Future<dynamic> pushNamed(String route, {Object? arguments}) =>
      NavigatorInstance.pushNamed(route.toString(),
          arguments: arguments, context: context);

  /// [pop]
  void pop<T extends Object?>([T? result]) async {
    final modalRoute = ModalRoute.of(context);
    final isFirst = modalRoute?.isFirst ?? false;
    bool closeOnPopFirstPage = false;
    final navigator = modalRoute?.navigator?.widget;
    if (navigator is MicroAppNavigator) {
      closeOnPopFirstPage = navigator.closeOnPopFirstPage;
    }
    if (isFirst && closeOnPopFirstPage) {
      return NavigatorInstance.pop(result);
    } else {
      return NavigatorInstance.pop(result, context);
    }
  }

  /// [pushReplacementNamed]
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return NavigatorInstance.pushReplacementNamed(routeName,
        arguments: arguments, result: result, context: context);
  }

  /// [push]
  Future<T?> push<T extends Object?>(Route<T> route) =>
      NavigatorInstance.push(route, context: context);

  /// [popAndPushNamed]
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return NavigatorInstance.popAndPushNamed(routeName,
        arguments: arguments, result: result, context: context);
  }

  /// [pushNamedAndRemoveUntil]
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
          String newRouteName, RoutePredicate predicate, {Object? arguments}) =>
      NavigatorInstance.pushNamedAndRemoveUntil(newRouteName, predicate,
          arguments: arguments, context: context);

  /// [popUntil]
  void popUntil(RoutePredicate predicate, {String? type}) {
    NavigatorInstance.popUntil(predicate, context: context);
  }
}
