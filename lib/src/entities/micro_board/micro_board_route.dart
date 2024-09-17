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
}
