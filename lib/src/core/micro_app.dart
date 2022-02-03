import '../controllers/micro_app_event_controller.dart';
import '../entities/router/base_route.dart';
import '../utils/typedefs.dart';
import 'micro_page.dart';

/// [MicroApp] contract
abstract class MicroApp implements MicroAppRoutes {
  List<MicroAppPage> get pages;
  Map<String, PageBuilder> get routes =>
      {for (var page in pages) page.name: page.builder};
  bool get hasRoutes => routes.isNotEmpty;
  MicroAppEventHandler? get microAppEventHandler;
}
