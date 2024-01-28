import 'package:example_external/pages/colors_float_page.dart';
import 'package:example_external/pages/page1.dart';
import 'package:example_external/pages/page3.dart';
import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import './pages/page2.dart';

class MicroApplication2 extends MicroAppWithBaseRoute
    with HandlerRegisterMixin {
  MicroApplication2() {
    registerEventHandler(MicroAppEventHandler((data) {
      logger.d([
        '(MicroAppExampleExternal - No channels) received here! :',
        data.name,
        data.payload
      ]);
    }, id: '123'));
  }

  @override
  List<MicroAppPage> get pages => [
        MicroAppPage<MicroAppNavigatorWidget>(
            description:
                'This route is responsible to expose internal routes. Using the the custom navigator [MicroAppNavigatorWidget] is possible to nest navigators.',
            route: baseRoute.microAppNavigator,
            pageBuilder: PageBuilder(
              widgetBuilder: (_, __) => MicroAppNavigatorWidget(
                  microBaseRoute: baseRoute,
                  initialRoute: Application2Routes().page1),
              transitionType: MicroPageTransitionType.rippleLeftDown,
            )),
        MicroAppPage<Page1>(
            route: baseRoute.page1,
            pageBuilder:
                PageBuilder(widgetBuilder: (_, settings) => const Page1())),
        MicroAppPage(
          route: baseRoute.page2,
          pageBuilder: PageBuilder(
              widgetBuilder: (_, settings) =>
                  Page2(title: settings.arguments as String?)),
        ),
        MicroAppPage<Page3>(
            route: baseRoute.page3,
            pageBuilder: PageBuilder(widgetBuilder: (_, __) => const Page3())),
        MicroAppPage<ColorsFloatPage>(
            description:
                'This page is responsible to change buttons and background colors',
            route: baseRoute.pageColors,
            pageBuilder:
                PageBuilder(widgetBuilder: (_, __) => const ColorsFloatPage())),
      ];

  @override
  Application2Routes get baseRoute => Application2Routes();

  @override
  String get name => 'Micro App 2';

  @override
  String get description => 'This micro app is a external package';
}
