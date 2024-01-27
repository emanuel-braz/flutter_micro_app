// ignore_for_file: mixin_inherits_from_not_object
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/src/utils/mixins/router_generator_mixin.dart';

import '../entities/micro_app_preferences.dart';
import '../entities/router/base_route.dart';
import 'micro_host.dart';

/// [MicroHostStatelessWidget]
abstract class MicroHostStatelessWidget extends StatelessWidget
    with MicroHost, RouterGenerator, IMicroAppBaseRoute {
  MicroHostStatelessWidget({super.key}) {
    registerRoutes();
  }

  /// App Base route of host application
  @visibleForTesting
  @override
  MicroAppRoute get baseRoute =>
      MicroAppPreferences.config.appBaseRoute.baseRoute;
}

/// [MicroHostStatefulWidget]
abstract class MicroHostStatefulWidget extends StatefulWidget
    with MicroHost, RouterGenerator, IMicroAppBaseRoute {
  MicroHostStatefulWidget({super.key}) {
    registerRoutes();
  }

  /// App Base route of host application
  @visibleForTesting
  @override
  MicroAppRoute get baseRoute =>
      MicroAppPreferences.config.appBaseRoute.baseRoute;
}
