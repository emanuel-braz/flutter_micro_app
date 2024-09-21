import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:go_router/go_router.dart';

class FmaGoRouterWrapper extends StatelessWidget {
  final Widget child;
  final String route;
  final dynamic parameters;
  final String? description;

  const FmaGoRouterWrapper({
    super.key,
    required this.child,
    required this.route,
    this.description,
    this.parameters,
  });

  @override
  Widget build(BuildContext context) => child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(StringProperty('description', description));
    properties.add(MessageProperty('route', route));
    properties.add(DiagnosticsProperty('parameters', parameters));
  }
}

/// A wrapper class for [GoRoute]
class FmaGoRoute extends GoRoute {
  final String description;
  final dynamic parameters;

  FmaGoRoute({
    required this.description,
    required super.path,
    super.name,
    super.pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <RouteBase>[],
    this.parameters,
    GoRouterWidgetBuilder? builder,
    Key? key,
  }) : super(
            builder: builder == null
                ? null
                : (context, state) => FmaGoRouterWrapper(
                      key: key,
                      description: description,
                      route: path,
                      parameters:
                          ParametersUtil.getParametersAsString(parameters),
                      child: builder(context, state),
                    ));

  MicroAppPage<Widget> toMicroAppPage({String parentPath = ''}) {
    String pathSegment = path;
    if (pathSegment == '/') pathSegment = '';
    parentPath = parentPath.replaceFirst(RegExp(r'^/+'), '/');
    final route = parentPath +
        (parentPath.endsWith('/') || pathSegment.startsWith('/')
            ? pathSegment
            : '/$pathSegment');

    String nameWithType = name ?? 'GoRoute';

    if (parameters != null && parameters is Function) {
      final type = parameters.runtimeType.toString().split(' => ').lastOrNull;
      if (type != null) {
        nameWithType += '<$type>';
      }
    }

    return MicroAppPage<Widget>(
      route: route,
      name: nameWithType,
      description: description,
      parameters: parameters,
      pageBuilder: PageBuilder(
        widgetBuilder: (context, arguments) => const SizedBox.shrink(),
      ),
    );
  }
}

/// A wrapper class for [ShellRoute]
class FmaShellRoute extends ShellRoute {
  final String description;
  final String name;

  FmaShellRoute({
    this.name = '',
    required this.description,
    required super.routes,
    super.redirect,
    super.builder,
    super.pageBuilder,
    super.observers,
    super.parentNavigatorKey,
    super.navigatorKey,
    super.restorationScopeId,
  });

  MicroAppPage<Widget> toMicroAppPage() {
    return MicroAppPage<Widget>(
      route: ' ',
      name: name.isNotEmpty ? name : 'ShellRoute',
      description: description,
      pageBuilder: PageBuilder(
        widgetBuilder: (context, arguments) => const SizedBox.shrink(),
      ),
    );
  }
}

/// A wrapper class for [StatefulShellRoute]
class FmaStatefulShellRoute extends StatefulShellRoute {
  final String name;
  final String description;

  FmaStatefulShellRoute({
    this.name = '',
    required this.description,
    required super.branches,
    required super.navigatorContainerBuilder,
    super.redirect,
    super.builder,
    super.pageBuilder,
    super.restorationScopeId,
    super.parentNavigatorKey,
  });

  MicroAppPage<Widget> toMicroAppPage() {
    return MicroAppPage<Widget>(
      route: ' ',
      name: name.isNotEmpty ? name : 'StatefulShellRoute',
      description: description,
      pageBuilder: PageBuilder(
        widgetBuilder: (context, arguments) => const SizedBox.shrink(),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
    properties.add(StringProperty('description', description));
  }
}

/// A wrapper class for [StatefulShellBranch]
class FmaStatefulShellBranch extends StatefulShellBranch {
  final String name;
  final String description;

  FmaStatefulShellBranch({
    this.name = '',
    required this.description,
    required super.routes,
    super.navigatorKey,
    super.initialLocation,
    super.restorationScopeId,
    super.observers,
  });

  MicroAppPage<Widget> toMicroAppPage() {
    return MicroAppPage<Widget>(
      route: ' ',
      name: name.isNotEmpty ? name : 'StatefulShellBranch',
      description: description,
      pageBuilder: PageBuilder(
        widgetBuilder: (context, arguments) => const SizedBox.shrink(),
      ),
    );
  }
}
