import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class ColorsFloatPage extends StatefulWidget {
  const ColorsFloatPage({Key? key}) : super(key: key);

  @override
  State<ColorsFloatPage> createState() => _ColorsFloatStatePlage();
}

class _ColorsFloatStatePlage extends State<ColorsFloatPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Container(
          height: 50,
          width: 50,
          color: Colors.red,
        ));
  }
}

class ColorsFloatFrame extends StatefulWidget {
  final MicroAppOverlayController controller;
  final Widget child;

  const ColorsFloatFrame(
      {required this.controller, required this.child, Key? key})
      : super(key: key);

  @override
  State<ColorsFloatFrame> createState() => _ColorsFloatFrameState();
}

class _ColorsFloatFrameState extends State<ColorsFloatFrame> {
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
      height: widget.controller.size.height,
      width: widget.controller.size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    widget.controller.close();
                  },
                  icon: const Icon(Icons.close)),
              IconButton(
                  onPressed: () {
                    // Maximize
                    widget.controller.x = 0;
                    widget.controller.y = 0;
                    widget.controller.size = MediaQuery.of(context).size;
                    widget.controller.isDraggable = false;
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                  },
                  icon: const Icon(Icons.crop_square)),
            ],
          ),
          Expanded(
            child: widget.child,
          )
        ],
      ),
    );
  }
}
