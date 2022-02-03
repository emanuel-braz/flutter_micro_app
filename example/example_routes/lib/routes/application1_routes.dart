import 'package:flutter_micro_app/flutter_micro_app.dart';

class Application1Routes extends MicroAppRoutes {
  @override
  MicroAppBaseRoute get baseRoute => MicroAppBaseRoute('example');
  String get pageExample => baseRoute.path('example_page');
  String get pageExampleMaterialApp =>
      baseRoute.path('material_app_page', ['all', 'examples']);
}
