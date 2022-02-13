// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:example_external/pages/colors_float_page.dart';
import 'package:example/pages/example_page_fragment.dart';
import 'package:example_external/example_external.dart';
import 'package:flutter/material.dart';
import 'package:example/pages/example_page.dart';
import 'package:example_routes/example_routes.dart';
import 'package:example/pages/material_app_page.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

// It could be a BLoC, Mobx, Redux, GetX or whatever
// but for now, it's just the incredible, super `ValueNotifier` :)
class ColorController extends ValueNotifier<MaterialColor> {
  ColorController([MaterialColor color = Colors.amber]) : super(color);
  void changeColor(MaterialColor color) => value = color;
}

// Global instances, just for example purposes
final backgroundColorController = ColorController();
final buttonsColorController = ColorController(Colors.green);

void main() {
  // Define micro app configurations here
  MicroAppPreferences.update(MicroAppConfig(
      nativeEventsEnabled: true, pathSeparator: MicroAppPathSeparator.slash));

  // Listen to navigation events
  final internalNavigationSubs =
      NavigatorInstance.eventController.flutterLoggerStream.listen((event) {
    logger.d('[flutter: navigation_log] -> $event');
  });

  final nativeNavigationCommands =
      NavigatorInstance.eventController.nativeCommandStream.listen((event) {
    logger.d('[navigation_command] -> $event');

    //* You can open pages that native asked
    if (event.method == Constants.methodNavigationCommand) {
      final map = jsonDecode(event.arguments.toString());
      final routeThatNativeRequestToOpen = map['route'];
      final arguments = map['arguments'];
      final type = map['type'];

      NavigatorInstance.pushNamed(routeThatNativeRequestToOpen,
          arguments: arguments, type: type);
      logger.d(
          'Native asked Flutter to open a Page -> $routeThatNativeRequestToOpen');
    }
  });

  runApp(MyApp());
}

// This micro app is registered in host application
// You can mix with the routes in order to get page routes in a easier way
// eg. pageExample, pageExampleMaterialApp
class MicroApplication1 extends MicroApp with Application1Routes {
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
            name: pageExample,
            builder: (context, arguments) => const ExamplePage()),
        MicroAppPage(
            name: pageExampleMaterialApp,
            builder: (context, arguments) => const MaterialAppPage()),
        MicroAppPage(
            name: pageExampleFragment,
            builder: (context, arguments) => const ExamplePageFragment()),
      ];

  // Event handler (listen all micro apps events on specifics channels)
  //
  // If you need the BuildContext, please register the handlers inside a widget
  // and unregister them on dispose method.
  // Or... you can use the mixin HandlerRegisterMixin on StatefulWidgets, in order to
  // help you don't forget to unregister them
  @override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((event) {
        // You can use freezed here if you prefer more safety in cover possibilities
        if (event.type == MaterialColor) {
          if (event.name == 'change_background_color') {
            backgroundColorController.changeColor(event.cast());
          } else if (event.name == 'change_buttons_color') {
            buttonsColorController.changeColor(event.cast());
          }
        }
        logger.d(
            ['(MicroAppExample) event received:', event.name, event.payload]);

        event.resultSuccess('success!!!');
      }, channels: const ['abc', 'chatbot', 'colors']);
}

// This is host application
class MyApp extends MicroHostStatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This is completely OPTIONAL!
  // Override `onGenerateRoute` in order to define a default error page (if needed)
  // or to request native app to open the route
  @override
  Route? onGenerateRoute(RouteSettings settings, {bool? routeNativeOnError}) {
    //! If you wish native app receive requests to open routes, IN CASE there
    //! is no route registered in Flutter, please set [routeNativeOnError: true]
    final pageRoute = super.onGenerateRoute(settings, routeNativeOnError: true);

    //? If you want to display a NOT_FOUND page, instead of get an error
    // if (pageRoute == null) {
    //   // If pageRoute is null, this route wasn't registered(unavailable)
    //   return MaterialPageRoute(
    //       builder: (_) => Scaffold(
    //             appBar: AppBar(),
    //             body: const Center(
    //               child: Text('Page Not Found'),
    //             ),
    //           ));
    // }
    return pageRoute;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: NavigatorInstance.navigatorKey, // Required
      onGenerateRoute: onGenerateRoute,
      initialRoute: baseRoute.name,
      navigatorObservers: [
        HeroController(),
        // NavigatorInstance // Add NavigatorInstance here, if you want to get didPop, didReplace and didPush events
      ],
      // home: const BaseHomePage(),
    );
  }

  // Base route of host application
  @override
  MicroAppBaseRoute get baseRoute => MicroAppBaseRoute('/');

  // Register all root [MicroAppPage]s in app host
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
            name: baseRoute.name, builder: (_, __) => const BaseHomePage())
      ];

  // Register all [MicroApp]s in app host
  @override
  List<MicroApp> get microApps => [MicroApplication1(), MicroApplication2()];

  // Listen to all micro apps events
  @override
  MicroAppEventHandler? get microAppEventHandler => null;
}

// This widget is registered as initial route in [MyApp] pages list
class BaseHomePage extends StatefulWidget {
  const BaseHomePage({Key? key}) : super(key: key);

  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          backgroundColorController,
          buttonsColorController,
        ]),
        builder: (context, child) {
          return Container(
              padding: const EdgeInsets.all(16),
              color: backgroundColorController.value,
              alignment: Alignment.center,
              child: ElevatedButtonTheme(
                data: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          buttonsColorController.value)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      child: const Text('Open Example MaterialApp'),
                      onPressed: () {
                        NavigatorInstance.pushNamed(
                            Application1Routes().pageExampleMaterialApp);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      child: const Text('Open Application2(package)'),
                      onPressed: () {
                        NavigatorInstance.pushNamed(
                            Application2Routes().baseRoute.name);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      child: const Text('Open a float page'),
                      onPressed: () {
                        final controller = MicroAppOverlayController(
                          isDraggable: true,
                          position: Offset(
                              (MediaQuery.of(context).size.width * .05), 100),
                          size:
                              Size(MediaQuery.of(context).size.width * .9, 160),
                          route: Application2Routes().pageColors,
                        );
                        controller.open(
                            builder: (child, controller) => ColorsFloatFrame(
                                  child: child,
                                  controller: controller,
                                ));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                        height: 50,
                        child: NavigatorInstance.getFragment(
                            Application1Routes().pageExampleFragment, context,
                            orElse: Container(
                              height: 200,
                              width: 200,
                              color: Colors.red,
                            )))
                  ],
                ),
              ));
        });
  }
}
