import 'package:flutter/widgets.dart';

import '../../../flutter_micro_app.dart';

class PageBuilder<T extends Widget> {
  final WidgetPageBuilder<T> builder;
  final MicroPageTransitionType? transitionType;

  PageBuilder({
    required this.builder,
    this.transitionType,
  });
}
