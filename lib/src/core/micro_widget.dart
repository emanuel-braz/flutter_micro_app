// ignore_for_file: mixin_inherits_from_not_object
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_micro_app/src/utils/mixins/router_generator_mixin.dart';

/// [MicroHostStatelessWidget]
abstract class MicroHostStatelessWidget extends StatelessWidget
    with MicroHost, RouterGenerator, IMicroAppBaseRoute {
  MicroHostStatelessWidget({Key? key}) : super(key: key) {
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
  MicroHostStatefulWidget({Key? key}) : super(key: key) {
    registerRoutes();
  }

  /// App Base route of host application
  @visibleForTesting
  @override
  MicroAppRoute get baseRoute =>
      MicroAppPreferences.config.appBaseRoute.baseRoute;
}
