import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class Page2 extends StatelessWidget {
  final String? title;
  const Page2({this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Page 2'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open page3 in nested Navigator)'),
              onPressed: () {
                context.maNav.pushNamed(Application2Routes().page3);
              },
            ),
            ElevatedButton(
              child: const Text('Close Page 2'),
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
