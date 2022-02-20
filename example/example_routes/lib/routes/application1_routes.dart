import 'package:flutter_micro_app/flutter_micro_app.dart';

class Application1Routes extends MicroAppBaseRoute {
  @override
  MicroAppRoute get baseRoute => MicroAppRoute('example');

  String get pageExample => path(['example_page']);
  String get pageExampleMaterialApp =>
      path(['material_app_page', 'all', 'examples']);
  String get pageExampleFragment => path(['fragment']);
}
