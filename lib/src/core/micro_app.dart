import '../entities/events/micro_app_event_handler.dart';
import '../entities/router/page_builder.dart';
import 'micro_page.dart';

/// [MicroApp] contract
abstract class MicroApp<T> {
  List<MicroAppPage> get pages;
  Map<String, PageBuilder> get pageBuilders =>
      {for (var page in pages) page.route: page.pageBuilder};
  bool get hasRoutes => pageBuilders.isNotEmpty;
  MicroAppEventHandler<T>? get microAppEventHandler;
}
