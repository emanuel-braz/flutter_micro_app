import 'package:flutter/material.dart';
import 'dart:math';

class RippleClipper extends CustomClipper<Path> {
  RippleClipper({required this.origin, required this.progress});
  final String origin;
  final double progress;

  @override
  Path getClip(Size size) {
    Map center = <String, Offset>{
      'Left': Offset(0, size.height),
      'Right': Offset(size.width, size.height),
      'LeftDown': Offset(0, 0),
      'RightDown': Offset(size.width, 0),
      'Middle': Offset(size.width * .5, size.height * .5),
    };
    Path path = Path();
    double radius = sqrt(pow(size.width, 2) + pow(size.height, 2));
    path.addOval(
        Rect.fromCircle(center: center[origin], radius: radius * progress));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

final t1 = Tween<Offset>(
  begin: const Offset(1.0, 0.0),
  end: const Offset(0.0, 0.0),
);
final t2 = Tween<Offset>(
  begin: const Offset(-1.0, 0.0),
  end: const Offset(0.0, 0.0),
);
final t3 = Tween<Offset>(
  begin: const Offset(0.0, 1.0),
  end: const Offset(0.0, 0.0),
);
final t4 = Tween<Offset>(
  begin: const Offset(0.0, -1.0),
  end: const Offset(0.0, 0.0),
);
final t5 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(-1.0, 0.0),
);
final t6 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(1.0, 0.0),
);
final t7 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(0.0, -1.0),
);
final t8 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(0.0, 1.0),
);

final t9 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(-0.8, 0.0),
);
final t10 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(0.8, 0.0),
);
final t11 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(0.0, -0.8),
);
final t12 = Tween<Offset>(
  begin: const Offset(0.0, 0.0),
  end: const Offset(0.0, 0.8),
);

final t13 = Tween<double>(
  begin: 1.0,
  end: 0.9,
);

final t14 = Tween<double>(
  begin: 0.9,
  end: 1.0,
);
