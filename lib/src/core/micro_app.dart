import '../entities/events/micro_app_event_handler.dart';
import '../entities/router/base_route.dart';
import '../utils/typedefs.dart';
import 'micro_page.dart';

/// [MicroApp] contract
abstract class MicroApp<T> implements MicroAppRoutes {
  List<MicroAppPage> get pages;
  Map<String, PageBuilder> get pageBuilders =>
      {for (var page in pages) page.name: page.builder};
  bool get hasRoutes => pageBuilders.isNotEmpty;
  MicroAppEventHandler<T>? get microAppEventHandler;
}
