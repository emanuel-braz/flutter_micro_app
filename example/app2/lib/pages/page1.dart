import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app_outlined),
          onPressed: () {
            context.maNav.pop();
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open page2'),
              onPressed: () {
                context.maNav.pushNamed(Application2Routes().page2);
              },
            ),
            ElevatedButton(
              child: const Text('Close Page 1'),
              onPressed: () {
                context.maNav.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
