import 'package:flutter/material.dart';

class ExamplePageFragment extends StatelessWidget {
  const ExamplePageFragment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.green,
      child: const SingleChildScrollView(
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white, fontSize: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 8),
              Text('This is a fragment ↑↓'),
              SizedBox(height: 8),
              Text('Don\'t pop this route'),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
