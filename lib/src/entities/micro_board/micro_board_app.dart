import 'micro_board_handler.dart';
import 'micro_board_route.dart';
import 'micro_board_webview.dart';

class MicroBoardApp {
  final String type;
  final String name;
  final String description;
  final String route;
  final List<MicroBoardRoute> pages;
  final List<MicroBoardHandler> handlers;
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
      'pages': pages.map((x) => x.toMap()).toList(),
      'handlers': handlers.map((x) => x.toMap()).toList(),
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

  MicroBoardApp copyWith({
    String? type,
    String? name,
    String? route,
    String? description,
    List<MicroBoardRoute>? pages,
    List<MicroBoardHandler>? handlers,
    List<MicroBoardWebview>? webviews,
  }) {
    return MicroBoardApp(
      type: type ?? this.type,
      name: name ?? this.name,
      route: route ?? this.route,
      description: description ?? this.description,
      pages: pages ?? this.pages,
      handlers: handlers ?? this.handlers,
      webviews: webviews ?? this.webviews,
    );
  }
}
