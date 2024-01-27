import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Page (Opened by Root)'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Close Page (Navigator.of(context).pop())'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              child: const Text('Close Page (NavigatorInstance.pop())'),
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
