import 'package:flutter_micro_app/src/entities/router/base_route.dart';

import '../entities/router/page_builder.dart';
import 'micro_page.dart';

/// [MicroApp] contract
abstract class MicroApp<T> {
  String get name;
  List<MicroAppPage> get pages;
  Map<String, PageBuilder> get pageBuilders =>
      {for (var page in pages) page.route: page.pageBuilder};
  bool get hasRoutes => pageBuilders.isNotEmpty;
}

abstract class MicroAppWithBaseRoute<T, D extends MicroAppBaseRoute>
    extends MicroApp<T> {
  D get baseRoute;
}
