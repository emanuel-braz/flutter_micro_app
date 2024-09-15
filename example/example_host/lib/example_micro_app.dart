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

import 'pages/route_builder_page.dart';

class ColorController extends ValueNotifier<MaterialColor> {
  ColorController([MaterialColor color = Colors.amber]) : super(color);
  void changeColor({MaterialColor? color, String? hexaColor}) {
    assert(color != null || hexaColor != null);

    if (color != null) {
      value = color;
      return;
    }

    final c = Color(int.parse(hexaColor!, radix: 16) + 0xFF000000);
    final mc = MaterialColor(c.value, <int, Color>{
      50: c.withOpacity(0.1),
      100: c.withOpacity(0.2),
      200: c.withOpacity(0.3),
      300: c.withOpacity(0.4),
      400: c.withOpacity(0.5),
      500: c.withOpacity(0.6),
      600: c.withOpacity(0.7),
      700: c.withOpacity(0.8),
      800: c.withOpacity(0.9),
      900: c.withOpacity(1.0),
    });

    value = mc;
  }
}

// Global instances, just for example purposes
final backgroundColorController = ColorController();
final buttonsColorController = ColorController(Colors.lightGreen);

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
                widgetBuilder: (context, arguments) => const ExamplePage())),
        MicroAppPage(
            route: routes.pageExampleMaterialApp,
            pageBuilder: PageBuilder(
                widgetBuilder: (context, arguments) => const MaterialAppPage(),
                transitionType: MicroPageTransitionType.slideZoomUp)),
        MicroAppPage<ExamplePageFragment>(
            description: 'Fragment can be used as a simple Widget',
            route: routes.pageExampleFragment,
            pageBuilder: PageBuilder(
                widgetBuilder: (context, arguments) =>
                    const ExamplePageFragment())),
        MicroAppPage<PopupExamplePage>(
          description: 'Popups can be used through WidgetRouteBuilder',
          route: routes.popupExample,
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) =>
                PopupExamplePage(title: settings.arguments as String),
            widgetRouteBuilder: (page) => PageRouteBuilder(
                barrierColor: Colors.black.withOpacity(0.2),
                barrierDismissible: false,
                opaque:
                    false, // IMPORTANT to remove the black background when using modals with transparent background
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation) =>
                    page),
          ),
        ),
        MicroAppPage(
          description: 'ModalBuilder can be used to show [PopupRoute]',
          route: routes.modalExample,
          pageBuilder: PageBuilder(
            modalBuilder: (settings) => ModalExamplePage(
                title: '${settings.arguments}'), // extendes PopupRoute
          ),
        ),
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
    registerEventHandler(MicroAppEventHandler(
      (event) {
        // You can use freezed here if you prefer more safety in cover possibilities
        if (event.name == 'change_background_color') {
          if (event.type == MaterialColor) {
            backgroundColorController.changeColor(color: event.cast());
          } else if (event.type == String) {
            backgroundColorController.changeColor(hexaColor: event.cast());
          }
        }
        if (event.name == 'change_buttons_color') {
          if (event.type == MaterialColor) {
            buttonsColorController.changeColor(color: event.cast());
          } else if (event.type == String) {
            buttonsColorController.changeColor(hexaColor: event.cast());
          }
        }

        logger.d([
          '(MicroAppExample - channel(colors) event received:',
          event.name,
          event.payload
        ]);

        event.resultSuccess('success!!!');
      },
      channels: const ['my_channel_with_conflict', 'ipsum', 'colors'],
    ));
  }
}
