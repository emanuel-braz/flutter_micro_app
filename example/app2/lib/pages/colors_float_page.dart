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
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          const Text(
            'Send commands to other microapp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Background'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  MicroAppEventController().emit(MicroAppEvent(
                      name: 'change_background_color',
                      payload: Colors.blue,
                      channels: const ['colors']));
                },
              ),
              ElevatedButton(
                child: const Text('Buttons'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.pink)),
                onPressed: () {
                  MicroAppEventController().emit(MicroAppEvent(
                      name: 'change_buttons_color',
                      payload: Colors.pink,
                      channels: const ['colors']));
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    MicroAppEventController().emit(MicroAppEvent(
        name: 'change_background_color',
        payload: Colors.amber,
        channels: const ['colors']));
    MicroAppEventController().emit(MicroAppEvent(
        name: 'change_buttons_color',
        payload: Colors.green,
        channels: const ['colors']));
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
              const Spacer(),
              Text(
                widget.controller.isDraggable
                    ? 'This is a draggable window'
                    : 'This is not a draggable window',
                style: TextStyle(
                    color: widget.controller.isDraggable
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.drag_indicator)
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
