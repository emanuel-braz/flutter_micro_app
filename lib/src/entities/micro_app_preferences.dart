import 'package:flutter_micro_app/flutter_micro_app.dart';

final maAppBaseRoute = MicroAppPreferences.config.appBaseRoute.baseRoute.route;

class MicroAppPreferences {
  static MicroAppConfig config = MicroAppConfig(
      nativeEventsEnabled: false,
      pathSeparator: MicroAppPathSeparator.slash,
      appBaseRoute: _DefaultBaseRoute());
  static update(MicroAppConfig _config) {
    config = _config;
  }
}

class MicroAppConfig {
  /// if (nativeEventsEnabled: false) it will suppress all native event emitters of micro-apps (default is false)
  /// ⚠️ if you don't intend to implement native side callbacks, then disable events [nativeEventsEnabled = false]
  /// in order to Flutter doesn't show exceptions in the console
  final bool nativeEventsEnabled;

  /// pathSeparator route segments
  final String pathSeparator;

  /// Default baseRoute = "/"
  final MicroAppBaseRoute appBaseRoute;

  /// disable all console logs
  final bool consoleLogsEnabled;

  /// Default page transition
  final MicroPageTransitionType pageTransitionType;

  MicroAppConfig(
      {this.nativeEventsEnabled = false,
      this.pathSeparator = MicroAppPathSeparator.slash,
      this.consoleLogsEnabled = false,
      MicroAppBaseRoute? appBaseRoute,
      this.pageTransitionType = MicroPageTransitionType.platform})
      : appBaseRoute = appBaseRoute ?? _DefaultBaseRoute();

  /// Protype [MicroAppConfig]
  MicroAppConfig copyWith({
    bool? nativeEventsEnabled,
    String? pathSeparator,
    MicroAppBaseRoute? appBaseRoute,
    bool? consoleLogsEnabled,
    MicroPageTransitionType? pageTransitionType,
  }) =>
      MicroAppConfig(
          nativeEventsEnabled: nativeEventsEnabled ?? this.nativeEventsEnabled,
          pathSeparator: pathSeparator ?? this.pathSeparator,
          appBaseRoute: appBaseRoute ?? _DefaultBaseRoute(),
          consoleLogsEnabled: consoleLogsEnabled ?? this.consoleLogsEnabled,
          pageTransitionType: pageTransitionType ?? this.pageTransitionType);
}

class _DefaultBaseRoute extends MicroAppBaseRoute {
  @override
  MicroAppRoute get baseRoute => MicroAppRoute('/');
}
