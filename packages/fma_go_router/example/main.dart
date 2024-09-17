// Using Go Router (Advanced and flexible)
import 'package:flutter/widgets.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_go_router/fma_go_router.dart';
import 'package:go_router/go_router.dart';

final FmaGoRouter fmaGoRouter = FmaGoRouter(
  name: 'GoRouter Example',
  description: 'This is an example of GoRouter',
  goRouter: GoRouter(
    navigatorKey: NavigatorInstance.navigatorKey,
    routes: <RouteBase>[
      FmaGoRoute(
        description: 'This is the boot page',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return Container();
        },
        routes: <RouteBase>[
          FmaGoRoute(
            description: 'This page has path parameter',
            path: 'page_with_id/:id',
            builder: (context, state) {
              return Container();
            },
          ),
          FmaGoRoute(
            description: 'This is the first page',
            path: 'page1',
            builder: (context, state) {
              return Container();
            },
          ),
        ],
      ),
    ],
  ),
);
