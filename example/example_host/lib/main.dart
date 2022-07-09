// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'dart:io';

import 'package:example_external/example_external.dart';
import 'package:example_external/pages/colors_float_page.dart';
import 'package:example_routes/example_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import 'example_micro_app.dart';

void main() {
  // Define micro app configurations here
  final isAndroid = Platform.isAndroid;
  MicroAppPreferences.update(MicroAppConfig(
      nativeEventsEnabled: isAndroid,
      nativeNavigationCommandEnabled: isAndroid,
      nativeNavigationLogEnabled: isAndroid,
      pageTransitionType: MicroPageTransitionType.platform));

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

  // Register a orphan handler, just to example purpose
  MicroAppEventController().registerHandler(MicroAppEventHandler((e) {}));

  runApp(MyApp());
}

// This is host application
class MyApp extends MicroHostStatelessWidget with HandlerRegisterMixin {
  MyApp({Key? key}) : super(key: key) {
    registerEventHandler(
        MicroAppEventHandler<int>((e) {}, channels: const ['day_update']));
  }

  // This is completely OPTIONAL!
  // Override `onGenerateRoute` in order to define a default error page (if needed)
  // or to request native app to open the route
  @override
  Route? onGenerateRoute(RouteSettings settings,
      {bool? routeNativeOnError, MicroAppBaseRoute? baseRoute}) {
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
      initialRoute:
          maAppBaseRoute, // or MicroAppPreferences.config.appBaseRoute.baseRoute.route
      navigatorObservers: [
        HeroController(),
        // NavigatorInstance // Add NavigatorInstance here, if you want to get didPop, didReplace and didPush events
      ],
    );
  }

  // Register all root [MicroAppPage]s in app host
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage<BaseHomePage>(
            route:
                maAppBaseRoute, // or MicroAppPreferences.config.appBaseRoute.baseRoute.route
            pageBuilder: PageBuilder(builder: (_, __) => const BaseHomePage()))
      ];

  // Register all [MicroApp]s in app host
  @override
  List<MicroApp> get initialMicroApps =>
      [MicroApplication1(), MicroApplication2()];
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
    MicroBoard.showButton();
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
                        context.maNav.pushNamed(
                            Application1Routes().pageExampleMaterialApp);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      child: const Text('Open Nested MicroAppNavigator'),
                      onPressed: () {
                        context.maNav.pushNamed(
                            Application2Routes().microAppNavigator,
                            arguments: 'microAppNavigator argument');
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
                        child: context.maNav.getPageWidget(
                            Application1Routes().pageExampleFragment,
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
