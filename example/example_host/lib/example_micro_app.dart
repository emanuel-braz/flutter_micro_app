// This micro app is registered in host application
// You can mix with the routes in order to get page routes in a easier way
// eg. pageExample, pageExampleMaterialApp
import 'package:example/pages/example_page.dart';
import 'package:example/pages/example_page_fragment.dart';
import 'package:example/pages/material_app_page.dart';
import 'package:example_routes/routes/application1_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class ColorController extends ValueNotifier<MaterialColor> {
  ColorController([MaterialColor color = Colors.amber]) : super(color);
  void changeColor(MaterialColor color) => value = color;
}

// Global instances, just for example purposes
final backgroundColorController = ColorController();
final buttonsColorController = ColorController(Colors.green);

class MicroApplication1 extends MicroApp with HandlerRegisterMixin {
  MicroApplication1() {
    registerAllMicroEventHandlers();
  }

  final routes = Application1Routes();

  @override
  List<MicroAppPage> get pages => [
        MicroAppPage<ExamplePage>(
            description: 'This is the example page',
            route: routes.pageExample,
            pageBuilder: PageBuilder(
                builder: (context, arguments) => const ExamplePage())),
        MicroAppPage(
            route: routes.pageExampleMaterialApp,
            pageBuilder: PageBuilder(
                builder: (context, arguments) => const MaterialAppPage(),
                transitionType: MicroPageTransitionType.slideZoomUp)),
        MicroAppPage<ExamplePageFragment>(
            description: 'Fragment can be used as a simple Widget',
            route: routes.pageExampleFragment,
            pageBuilder: PageBuilder(
                builder: (context, arguments) => const ExamplePageFragment())),
      ];

  @override
  String get name => 'Micro App 1';

  registerAllMicroEventHandlers() {
    // Event handler (listen all micro apps events on specifics channels)
    //
    // If you need the BuildContext, please register the handlers inside a widget
    // and unregister them on dispose method.
    // Or... you can use the mixin HandlerRegisterMixin on StatefulWidgets, in order to
    // help you don't forget to unregister them
    registerEventHandler<MaterialColor>(MicroAppEventHandler(
      (event) {
        // You can use freezed here if you prefer more safety in cover possibilities
        if (event.type == MaterialColor) {
          if (event.name == 'change_background_color') {
            backgroundColorController.changeColor(event.cast());
          } else if (event.name == 'change_buttons_color') {
            buttonsColorController.changeColor(event.cast());
          }
        }
        logger.d([
          '(MicroAppExample - channel(colors) event received:',
          event.name,
          event.payload
        ]);

        event.resultSuccess('success!!!');
      },
      channels: const ['lorem', 'ipsum', 'colors'],
    ));

    registerEventHandler<String>(MicroAppEventHandler(
      (event) {},
      channels: const ['config'],
    ));
  }
}
