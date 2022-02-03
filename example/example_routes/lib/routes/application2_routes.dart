import 'package:flutter_micro_app/flutter_micro_app.dart';

class Application2Routes extends MicroAppRoutes {
  @override
  MicroAppBaseRoute get baseRoute => MicroAppBaseRoute('example_external');
  String get page2 => baseRoute.path('page2');
}
