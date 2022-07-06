import '../../flutter_micro_app.dart';

/// [MicroHost] contract
abstract class MicroHost implements MicroApp {
  static bool _microAppsRegistered = false;

  static List<MicroApp> microApps = [];
  List<MicroApp> get initialMicroApps;

  static MicroApp? registerMicroApp(MicroApp microApp) {
    if (microApps.isEmpty) {
      microApps.add(microApp);
      return microApp;
    }

    final containsMicroApp = microApps.contains(microApp);
    if (!containsMicroApp) {
      microApps.add(microApp);
      return microApp;
    }
  }

  @override
  Map<String, PageBuilder> get pageBuilders => NavigatorInstance.pageBuilders;

  @override
  bool get hasRoutes => pageBuilders.isNotEmpty;

  void registerRoutes() {
    if (_microAppsRegistered) return;

    NavigatorInstance.addPageBuilders(
        {for (var page in pages) page.route: page.pageBuilder});

    registerMicroApp(this);

    for (MicroApp microapp in initialMicroApps) {
      if (microapp.hasRoutes) {
        NavigatorInstance.addPageBuilders(microapp.pageBuilders);
      }
      registerMicroApp(microapp);
    }
    _microAppsRegistered = true;
  }
}
