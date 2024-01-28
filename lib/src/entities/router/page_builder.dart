import 'package:flutter/widgets.dart';

import '../../utils/enums/micro_page_transition_type.dart';
import '../../utils/typedefs.dart';

class PageBuilder<T extends Widget> {
  final WidgetPageBuilder<T>? builder;
  WidgetPageBuilder<T>? widgetBuilder;

  final WidgetRouteBuilder? widgetRouteBuilder;
  final ModalBuilder? modalBuilder;
  final MicroPageTransitionType? transitionType;

  PageBuilder({
    this.transitionType,
    this.widgetRouteBuilder,
    this.modalBuilder,
    this.widgetBuilder,
    @Deprecated('Use [widgetBuilder] instead. Will be removed in v0.15.0')
    this.builder,
  }) {
    if (builder != null) {
      widgetBuilder = builder;
    }

    assert(
        (widgetBuilder != null || modalBuilder != null) &&
            (widgetBuilder == null || modalBuilder == null),
        'You must provide either a widgetBuilder or a modalBuilder');
  }

  bool get hasWidgetBuilder => widgetBuilder != null;
  bool get hasWidgetRouteBuilder => widgetRouteBuilder != null;
  bool get hasModalBuilder => modalBuilder != null;
}
