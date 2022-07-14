import 'package:flutter/material.dart';

import '../../entities/router/base_route.dart';
import '../../utils/ambiguate.dart';
import '../../utils/mixins/router_generator_mixin.dart';

class MicroAppNavigatorWidget extends StatefulWidget {
  final MicroAppBaseRoute microBaseRoute;
  final String? initialRoute;
  final bool? closeOnPopFirstPage;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final bool? routeNativeOnError;
  final List<Page<dynamic>>? pages;
  final List<NavigatorObserver>? observers;
  final List<Route<dynamic>> Function(NavigatorState, String)?
      onGenerateInitialRoutes;
  final bool Function(Route<dynamic>, dynamic)? onPopPage;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final bool? reportsRouteUpdateToEngine;
  final bool? requestFocus;
  final String? restorationScopeId;
  final TransitionDelegate<dynamic>? transitionDelegate;

  const MicroAppNavigatorWidget(
      {Key? key,
      required this.microBaseRoute,
      this.initialRoute,
      this.closeOnPopFirstPage,
      this.onGenerateRoute,
      this.routeNativeOnError,
      this.pages,
      this.observers,
      this.onGenerateInitialRoutes,
      this.onPopPage,
      this.onUnknownRoute,
      this.reportsRouteUpdateToEngine,
      this.requestFocus,
      this.restorationScopeId,
      this.transitionDelegate})
      : super(key: key);

  @override
  _MicroAppNavigatorWidgetState createState() =>
      _MicroAppNavigatorWidgetState();
}

class _MicroAppNavigatorWidgetState extends State<MicroAppNavigatorWidget>
    with RouterGenerator {
  RouteSettings? initialSettings;

  @override
  void initState() {
    ambiguate(WidgetsBinding.instance)!.addPostFrameCallback(
        (timeStamp) => initialSettings = ModalRoute.of(context)?.settings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MicroAppNavigator(
      key: widget.key,
      microBaseRoute: widget.microBaseRoute,
      initialRoute:
          widget.initialRoute ?? widget.microBaseRoute.baseRoute.route,
      onGenerateRoute: widget.onGenerateRoute ??
          (settings) => onGenerateRoute(settings,
              baseRoute: widget.microBaseRoute,
              routeNativeOnError: widget.routeNativeOnError),
      pages: widget.pages ?? const <Page<dynamic>>[],
      observers: widget.observers ?? const <NavigatorObserver>[],
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes ??
          Navigator.defaultGenerateInitialRoutes,
      onPopPage: widget.onPopPage,
      onUnknownRoute: widget.onUnknownRoute,
      reportsRouteUpdateToEngine: widget.reportsRouteUpdateToEngine ?? true,
      requestFocus: widget.requestFocus ?? true,
      restorationScopeId: widget.restorationScopeId,
      transitionDelegate: widget.transitionDelegate ??
          const DefaultTransitionDelegate<dynamic>(),
    );
  }
}

class MicroAppNavigator extends Navigator {
  static RouteSettings? getInitialRouteSettings(BuildContext context) => context
      .findAncestorStateOfType<_MicroAppNavigatorWidgetState>()
      ?.initialSettings;

  final MicroAppBaseRoute microBaseRoute;
  final bool closeOnPopFirstPage;

  const MicroAppNavigator(
      {Key? key,
      required this.microBaseRoute,
      String? initialRoute,
      this.closeOnPopFirstPage = true,
      Route<dynamic>? Function(RouteSettings)? onGenerateRoute,
      bool? routeNativeOnError,
      List<Page<dynamic>>? pages,
      List<NavigatorObserver>? observers,
      List<Route<dynamic>> Function(NavigatorState, String)?
          onGenerateInitialRoutes,
      bool Function(Route<dynamic>, dynamic)? onPopPage,
      Route<dynamic>? Function(RouteSettings)? onUnknownRoute,
      bool? reportsRouteUpdateToEngine,
      bool? requestFocus,
      String? restorationScopeId,
      TransitionDelegate<dynamic>? transitionDelegate})
      : super(
          key: key,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          pages: pages ?? const <Page<dynamic>>[],
          observers: observers ?? const <NavigatorObserver>[],
          onGenerateInitialRoutes:
              onGenerateInitialRoutes ?? Navigator.defaultGenerateInitialRoutes,
          onPopPage: onPopPage,
          onUnknownRoute: onUnknownRoute,
          reportsRouteUpdateToEngine: reportsRouteUpdateToEngine ?? true,
          requestFocus: requestFocus ?? true,
          restorationScopeId: restorationScopeId,
          transitionDelegate:
              transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}
