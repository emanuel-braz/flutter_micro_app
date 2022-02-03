import 'package:example/pages/material_app_page_initial.dart';
import 'package:flutter/material.dart';

class MaterialAppPage extends StatelessWidget {
  const MaterialAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: onGenerateRoute,
      initialRoute: '/',
      navigatorObservers: [HeroController()],
    );
  }

  // Internal Routing (NavigatorInstance agnostic)
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const MaterialAppPageInitial());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(),
                  body: Container(
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Text('Page Not Found (Example App)'),
                  ),
                ));
    }
  }
}
