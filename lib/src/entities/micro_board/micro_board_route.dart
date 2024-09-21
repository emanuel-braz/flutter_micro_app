import '../../utils/parameters_util/parameters_util.dart';

class MicroBoardRoute {
  final String route;
  final String widget;
  final String description;
  final String name;
  final dynamic parameters;

  String get parametersAsString =>
      ParametersUtil.getParametersAsString(parameters);

  MicroBoardRoute({
    required this.route,
    required this.widget,
    required this.description,
    required this.name,
    this.parameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'route': route,
      'widget': widget,
      'description': description,
      'name': name,
      'parameters': ParametersUtil.getParametersAsString(parameters),
    };
  }

  factory MicroBoardRoute.fromMap(Map<String, dynamic> map) {
    return MicroBoardRoute(
      route: map['route'],
      widget: map['widget'],
      description: map['description'],
      name: map['name'],
      parameters: map['parameters'],
    );
  }
}
