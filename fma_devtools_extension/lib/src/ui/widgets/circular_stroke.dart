import 'dart:math';

import 'package:flutter/material.dart';

class DashboardElement {
  final String label;
  final int value;

  DashboardElement({required this.label, required this.value});
}

class CircularDashboard extends StatefulWidget {
  final List<DashboardElement> elements;

  const CircularDashboard({
    Key? key,
    required this.elements,
  }) : super(key: key);

  @override
  State<CircularDashboard> createState() => _CircularDashboardState();
}

class _CircularDashboardState extends State<CircularDashboard> {
  String currLabel = 'Micro App(s)';

  @override
  Widget build(BuildContext context) {
    int totalValue =
        widget.elements.fold(0, (sum, element) => sum + element.value);

    return MouseRegion(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CustomPaint(
                size: const Size(62, 62),
                painter: CircularDashboardPainter(widget.elements, totalValue,
                    _getRandomColors(widget.elements.length)),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    widget.elements.length.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(currLabel),
        ],
      ),
    );
  }

  List<Color> _getRandomColors(int totalColors) {
    List<Color> colors = [];
    double hueStep = 360 / totalColors;

    for (int i = 0; i < totalColors; i++) {
      double hue = (i * hueStep) % 360;

      // Skip red hues (between 0° and 30° or between 330° and 360°)
      if (hue < 30 || hue > 330) {
        hue = (hue + 60) % 360; // Shift hue to avoid red
      }

      Color color = HSVColor.fromAHSV(1.0, hue, 0.8, 0.9).toColor();
      colors.add(color);
    }

    return colors.length == 1 ? [Colors.green] : colors;
  }
}

class CircularDashboardPainter extends CustomPainter {
  final List<DashboardElement> elements;
  final int totalValue;
  final List<Color> colors;

  CircularDashboardPainter(this.elements, this.totalValue, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 8.0;
    double startAngle = -pi / 2;

    for (int i = 0; i < elements.length; i++) {
      double sweepAngle = 2 * pi * (elements[i].value / totalValue);
      circlePaint.color = colors[i % colors.length];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        circlePaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CircularDashboardPainter oldDelegate) {
    return true;
  }
}
