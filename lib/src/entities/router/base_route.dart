import '../micro_app_preferences.dart';

abstract mixin class IMicroAppBaseRoute {
  MicroAppRoute get baseRoute;
}

class MicroAppRoute {
  /// Gets the segments (initial path not included)
  final List<String> segments;

  /// Gets only the initial path
  final String path;
  MicroAppRoute(this.path, [this.segments = const <String>[]]);

  /// Gets the full route
  String get route => _getFullPath();

  @override
  String toString() {
    return route;
  }

  _getFullPath() {
    String pathSeparator = MicroAppPreferences.config.pathSeparator;
    String route = path;
    for (var segment in segments) {
      route += '$pathSeparator$segment';
    }
    return route;
  }
}

abstract class MicroAppBaseRoute implements IMicroAppBaseRoute {
  String path(List<String> path) => MicroAppRoute(toString(), path).toString();

  @override
  String toString() => baseRoute.path;
}
