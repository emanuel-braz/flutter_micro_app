import '../../../flutter_micro_app.dart';

class PageBuilder {
  final WidgetPageBuilder builder;
  final MicroPageTransitionType? transitionType;

  PageBuilder({
    required this.builder,
    this.transitionType,
  });
}
