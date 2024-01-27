import 'micro_board_handler.dart';
import 'micro_board_route.dart';

class MicroBoardApp {
  final String type;
  final String name;
  final String description;
  final String route;
  final List<MicroBoardRoute> pages;
  final List<MicroBoardHandler> handlers;

  MicroBoardApp({
    required this.type,
    required this.name,
    required this.description,
    required this.route,
    required this.pages,
    required this.handlers,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'description': description,
      'route': route,
      'pages': pages.map((x) => x.toMap()).toList(),
      'handlers': handlers.map((x) => x.toMap()).toList(),
    };
  }
}
