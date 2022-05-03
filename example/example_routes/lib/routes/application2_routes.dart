import 'package:flutter_micro_app/flutter_micro_app.dart';

class Application2Routes extends MicroAppBaseRoute {
  @override
  MicroAppRoute get baseRoute => MicroAppRoute('example_external');

  String get microAppNavigator => path(['microAppNavigator']);
  String get page1 => path(['page1']);
  String get page2 => path(['page2']);
  String get page3 => path(['page3']);
  String get pageColors => path(['pageColors']);
}
