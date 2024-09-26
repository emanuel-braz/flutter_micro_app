import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  final String title;
  final String description;
  final Color? borderColor;

  const CircularWidget({
    super.key,
    required this.title,
    required this.description,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: borderColor ?? Colors.green, width: 4)),
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(description, textAlign: TextAlign.center),
      ],
    );
  }
}
