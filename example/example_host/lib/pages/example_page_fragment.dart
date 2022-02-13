import 'package:flutter/material.dart';

class ExamplePageFragment extends StatelessWidget {
  const ExamplePageFragment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.green,
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 38),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('This is a fragment ↑'),
                SizedBox(
                  height: 8,
                ),
                Text('Don\'t pop this route'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
