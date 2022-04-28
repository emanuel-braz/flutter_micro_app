import 'package:example_external/pages/colors_float_page.dart';
import 'package:example_external/pages/page1.dart';
import 'package:example_external/pages/page3.dart';

import './pages/page2.dart';
import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class MicroApplication2 extends MicroApp {
  final baseRoute = Application2Routes();
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
            route: baseRoute.baseRoute.route,
            pageBuilder: PageBuilder(
              builder: (context, arguments) => MicroAppNavigatorWidget(
                  microBaseRoute: baseRoute,
                  initialRoute: Application2Routes().page1),
              transitionType: MicroPageTransitionType.rippleLeftDown,
            )),
        MicroAppPage(
            route: baseRoute.page1,
            pageBuilder:
                PageBuilder(builder: (context, arguments) => const Page1())),
        MicroAppPage(
          route: baseRoute.page2,
          pageBuilder:
              PageBuilder(builder: (context, arguments) => const Page2()),
        ),
        MicroAppPage(
            route: baseRoute.page3,
            pageBuilder:
                PageBuilder(builder: (context, arguments) => const Page3())),
        MicroAppPage(
            route: baseRoute.pageColors,
            pageBuilder:
                PageBuilder(builder: (_, __) => const ColorsFloatPage())),
      ];

  @override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((data) {
        logger.d([
          '(MicroAppExampleExternal) ALSO received here! :',
          data.name,
          data.payload
        ]);
      }, id: '123');
}
