import 'package:flutter/widgets.dart';

import '../../utils/enums/micro_page_transition_type.dart';
import '../../utils/typedefs.dart';

class PageBuilder<T extends Widget> {
  final WidgetPageBuilder<T> builder;
  final MicroPageTransitionType? transitionType;

  PageBuilder({
    required this.builder,
    this.transitionType,
  });
}
