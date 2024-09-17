import 'package:flutter/widgets.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_go_router/src/index.dart';
import 'package:go_router/go_router.dart';

/// A wrapper class for [GoRouter] that contains a list of [MicroAppPage]s.
class FmaGoRouter {
  /// The [GoRouter] instance.
  final GoRouter goRouter;

  /// The name of the [FmaGoRouter].
  final String name;

  /// The description of the [FmaGoRouter].
  final String? description;

  final _microPages = <MicroAppPage<Widget>>[];
  List<MicroAppPage<Widget>> get microPages => _microPages;

  FmaGoRouter({
    required this.goRouter,
    required this.name,
    this.description,
  }) {
    _addMicroPages(goRouter.configuration.routes);
  }

  List<MicroAppPage<Widget>> _addMicroPages(List<RouteBase> routes,
      [String parentPath = '']) {
    for (final route in routes) {
      if (route is FmaGoRoute) {
        _microPages.add(route.toMicroAppPage(parentPath: parentPath));
        if (route.routes.isNotEmpty) {
          _addMicroPages(
              route.routes,
              (parentPath.endsWith('/') ? parentPath : '$parentPath/') +
                  route.path);
        }
      } else if (route is FmaShellRoute) {
        _microPages.add(route.toMicroAppPage());
        if (route.routes.isNotEmpty) {
          _addMicroPages(route.routes, parentPath);
        }
      } else if (route is FmaStatefulShellRoute) {
        _microPages.add(route.toMicroAppPage());
        if (route.branches.isNotEmpty) {
          _addMicroPages(route.routes, parentPath);
        }
      } else if (route is FmaStatefulShellBranch) {
        _microPages.add((route as FmaStatefulShellBranch).toMicroAppPage());
        if (route.routes.isNotEmpty) {
          _addMicroPages(route.routes, parentPath);
        }
      }
    }

    return _microPages;
  }
}
