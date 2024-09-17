class MicroBoardRoute {
  final String route;
  final String widget;
  final String description;
  final String name;

  MicroBoardRoute({
    required this.route,
    required this.widget,
    required this.description,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'route': route,
      'widget': widget,
      'description': description,
      'name': name,
    };
  }

  factory MicroBoardRoute.fromMap(Map<String, dynamic> map) {
    return MicroBoardRoute(
      route: map['route'],
      widget: map['widget'],
      description: map['description'],
      name: map['name'],
    );
  }
}
