import '../../flutter_micro_app.dart';

/// [MicroHost] contract
abstract class MicroHost implements MicroApp {
  static bool _microAppsRegistered = false;

  List<MicroApp> get microApps;

  @override
  Map<String, PageBuilder> get pageBuilders => NavigatorInstance.pageBuilders;

  @override
  bool get hasRoutes => pageBuilders.isNotEmpty;

  void registerRoutes() {
    if (_microAppsRegistered) return;

    NavigatorInstance.addPageBuilders(
        {for (var page in pages) page.route: page.pageBuilder});

    _registerEventHandler(this);

    for (MicroApp microapp in microApps) {
      if (microapp.hasRoutes) {
        NavigatorInstance.addPageBuilders(microapp.pageBuilders);
      }
      _registerEventHandler(microapp);
    }
    _microAppsRegistered = true;
  }

  void _registerEventHandler(MicroApp microapp) {
    final handler = microapp.microAppEventHandler;
    MicroAppEventController().registerHandler(handler);
  }
}
