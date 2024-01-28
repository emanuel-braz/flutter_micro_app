class MicroBoardRoute {
  final String route;
  final String widget;
  final String description;

  MicroBoardRoute({
    required this.route,
    required this.widget,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'route': route,
      'widget': widget,
      'description': description,
    };
  }

  factory MicroBoardRoute.fromMap(Map<String, dynamic> map) {
    return MicroBoardRoute(
      route: map['route'],
      widget: map['widget'],
      description: map['description'],
    );
  }
}
