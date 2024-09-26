import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fma_devtools_extension/src/controllers/fma_controller.dart';

import 'src/ui/pages/main_app_widget.dart';

void main() {
  runApp(const FmaDevtoolsExtension());
}

class FmaDevtoolsExtension extends StatefulWidget {
  const FmaDevtoolsExtension({Key? key}) : super(key: key);

  @override
  State<FmaDevtoolsExtension> createState() => _FmaDevtoolsExtensionState();
}

class _FmaDevtoolsExtensionState extends State<FmaDevtoolsExtension> {
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => FmaController().updateView());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DevToolsExtension(
      child: ValueListenableBuilder(
          valueListenable: FmaController(),
          builder: (context, value, child) {
            if (value.microBoardMap == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Scaffold(body: MainAppWidget());
            }
          }),
    );
  }
}
