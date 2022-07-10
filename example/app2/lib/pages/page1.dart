import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  void initState() {
    ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((timeStamp) {
      debugPrint(
          'Nested InitialRouteSettings: ${MicroAppNavigator.getInitialRouteSettings(context).toString()}');
    });

    super.initState();
  }

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
                context.maNav.pushNamed(Application2Routes().page2,
                    arguments: 'Title Page 2');
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
