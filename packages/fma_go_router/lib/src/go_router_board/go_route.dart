import 'package:flutter/widgets.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:go_router/go_router.dart';

class FmaGoRoute extends GoRoute {
  final String description;
  FmaGoRoute({
    required this.description,
    required super.path,
    super.name,
    super.builder,
    super.pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <RouteBase>[],
  });

  MicroAppPage<Widget> toMicroAppPage({String parentPath = ''}) {
    String pathSegment = path;
    if (pathSegment == '/') pathSegment = '';
    parentPath = parentPath.replaceFirst(RegExp(r'^/+'), '/');
    final route = parentPath +
        (parentPath.endsWith('/') || pathSegment.startsWith('/')
            ? pathSegment
            : '/$pathSegment');

    return MicroAppPage<Widget>(
      route: route,
      name: name ?? 'GoRoute',
      description: description,
      pageBuilder: PageBuilder(
        widgetBuilder: (context, arguments) => const SizedBox.shrink(),
      ),
    );
  }
}

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
}

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