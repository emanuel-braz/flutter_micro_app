import 'package:flutter/material.dart';

import '../../../../flutter_micro_app.dart';

class MicroAppOverlay extends StatefulWidget {
  final MicroAppOverlayController controller;
  final MicroAppFloatPageBuilder? builder;
  const MicroAppOverlay({required this.controller, this.builder, Key? key})
      : super(key: key);

  @override
  State<MicroAppOverlay> createState() => _MicroAppOverlayState();
}

class _MicroAppOverlayState extends State<MicroAppOverlay> {
  late Widget child;
  late MicroAppOverlayController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    child = widget.builder != null
        ? widget.builder!(
            NavigatorInstance.getPageWidget(widget.controller.route, context),
            widget.controller)
        : NavigatorInstance.getPageWidget(widget.controller.route, context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (_, __) {
        return Positioned(
          height: controller.size.height,
          width: controller.size.width,
          top: controller.y,
          left: controller.x,
          child: GestureDetector(
              onPanUpdate: (tapInfo) {
                if (widget.controller.isDraggable) {
                  controller.x += tapInfo.delta.dx;
                  controller.y += tapInfo.delta.dy;
                }
              },
              child: Material(
                child: child,
                color: Colors.transparent,
              )),
        );
      },
      animation: controller,
    );
  }
}
