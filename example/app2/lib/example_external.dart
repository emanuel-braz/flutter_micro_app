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
        MicroAppPage(
            route: baseRoute.microAppNavigator,
            pageBuilder: PageBuilder(
              builder: (_, __) => MicroAppNavigatorWidget(
                  microBaseRoute: baseRoute,
                  initialRoute: Application2Routes().page1),
              transitionType: MicroPageTransitionType.rippleLeftDown,
            )),
        MicroAppPage(
            route: baseRoute.page1,
            pageBuilder: PageBuilder(builder: (_, settings) => const Page1())),
        MicroAppPage(
          route: baseRoute.page2,
          pageBuilder: PageBuilder(
              builder: (_, settings) =>
                  Page2(title: settings.arguments as String?)),
        ),
        MicroAppPage(
            route: baseRoute.page3,
            pageBuilder: PageBuilder(builder: (_, __) => const Page3())),
        MicroAppPage(
            route: baseRoute.pageColors,
            pageBuilder:
                PageBuilder(builder: (_, __) => const ColorsFloatPage())),
      ];

  @override
  Application2Routes get baseRoute => Application2Routes();

  @override
  String get name => 'Micro App 2';
}
