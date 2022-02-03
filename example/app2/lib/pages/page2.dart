import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Close Page 2 (NavigatorInstance.pop())'),
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
