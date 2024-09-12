import 'micro_board_handler.dart';
import 'micro_board_route.dart';
import 'micro_board_webview.dart';

class MicroBoardApp {
  final String type;
  final String name;
  final String route;
  final String? description;
  final List<MicroBoardRoute>? pages;
  final List<MicroBoardHandler>? handlers;
  final List<MicroBoardWebview>? webviews;

  MicroBoardApp({
    required this.type,
    required this.name,
    required this.description,
    required this.route,
    required this.pages,
    required this.handlers,
    required this.webviews,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'description': description,
      'route': route,
      'pages': pages?.map((e) => e.toMap()).toList(),
      'handlers': handlers?.map((e) => e.toMap()).toList(),
      'webviews': webviews?.map((e) => e.toMap()).toList(),
    };
  }

  factory MicroBoardApp.fromMap(Map<String, dynamic> map) {
    return MicroBoardApp(
      type: map['type'],
      name: map['name'],
      description: map['description'],
      route: map['route'],
      pages: (map['pages'] as List? ?? [])
          .map((e) => MicroBoardRoute.fromMap(e))
          .toList(),
      handlers: (map['handlers'] as List? ?? [])
          .map((e) => MicroBoardHandler.fromMap(e))
          .toList(),
      webviews: (map['webviews'] as List? ?? [])
          .map((e) => MicroBoardWebview.fromMap(e))
          .toList(),
    );
  }
}
