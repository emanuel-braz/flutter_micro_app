import '../utils/constants/path_separator.dart';

class MicroAppPreferences {
  static MicroAppConfig config = MicroAppConfig(
      nativeEventsEnabled: false, pathSeparator: MicroAppPathSeparator.dot);
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

  MicroAppConfig(
      {required this.nativeEventsEnabled, required this.pathSeparator});

  MicroAppConfig copyWith({bool? nativeEventsEnabled, String? pathSeparator}) =>
      MicroAppConfig(
          nativeEventsEnabled: nativeEventsEnabled ?? this.nativeEventsEnabled,
          pathSeparator: pathSeparator ?? this.pathSeparator);
}
