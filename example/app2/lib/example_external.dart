import './pages/page2.dart';
import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class MicroApplication2 extends MicroApp with Application2Routes {
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
            name: baseRoute.name,
            builder: (context, arguments) => const Application2Initial()),
        MicroAppPage(
            name: page2, builder: (context, arguments) => const Page2()),
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

class Application2Initial extends StatelessWidget {
  const Application2Initial({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application 2 Initial'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open Page2'),
              onPressed: () {
                NavigatorInstance.pushNamed(Application2Routes().page2);
              },
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              child: const Text('Close MicroApp Application2'),
              onPressed: () {
                NavigatorInstance.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
