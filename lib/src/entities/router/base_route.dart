import '../micro_app_preferences.dart';

abstract class MicroAppRoutes {
  MicroAppBaseRoute get baseRoute;
}

class MicroAppBaseRoute {
  final String name;
  static String pathSeparator = MicroAppPreferences.config.pathSeparator;

  MicroAppBaseRoute(this.name);

  String path(String path, [List<String> segments = const []]) {
    String route = '$name$pathSeparator$path';
    for (var segment in segments) {
      route += '$pathSeparator$segment';
    }
    return route;
  }

  @override
  String toString() => name;
}
