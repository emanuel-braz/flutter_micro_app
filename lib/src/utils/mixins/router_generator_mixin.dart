import 'package:flutter/material.dart';

import '../../../dependencies.dart';
import '../../../flutter_micro_app.dart';

mixin RouterGenerator {
  Route<dynamic>? onGenerateRoute(RouteSettings settings,
      {bool? routeNativeOnError, MicroAppBaseRoute? baseRoute}) {
    PageRoute<dynamic>? pageRoute = NavigatorInstance.getPageRoute(settings,
        routeNativeOnError: routeNativeOnError, baseRoute: baseRoute);
    if (pageRoute == null) {
      logger.e('Error: [onGenerateRoute] PageRoute is null',
          error: 'Route "${settings.name}" not found!');
    }

    return pageRoute;
  }
}
