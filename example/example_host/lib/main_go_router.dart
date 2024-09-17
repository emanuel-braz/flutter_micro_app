import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_go_router/fma_go_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

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
          return const BaseHomePage();
        },
        routes: <RouteBase>[
          FmaGoRoute(
            description: 'This page has path parameter',
            path: 'page_with_id/:id',
            builder: (context, state) {
              return ExamplePageA(
                  'page with id = ' + (state.pathParameters['id'] ?? ''));
            },
          ),
          FmaGoRoute(
            description: 'This is the first page',
            path: 'page1',
            builder: (context, state) {
              return const ExamplePageA('page1');
            },
          ),
          FmaGoRoute(
              description: 'This is the seconds page',
              path: 'page2',
              name: 'Page 2',
              builder: (context, state) {
                return const ExamplePageA('page2');
              },
              routes: [
                FmaShellRoute(
                  name: 'ShellRoute Name',
                  description: 'This is ShellRoute from page 2',
                  builder: (BuildContext context, GoRouterState state,
                      Widget child) {
                    return Scaffold(
                      appBar: AppBar(title: const Text('App Shell')),
                      body: Center(
                        child: child,
                      ),
                    );
                  },
                  routes: [
                    FmaGoRoute(
                      description: 'This is one GoRoute from ShellRoute',
                      path: 'page3',
                      builder: (BuildContext context, GoRouterState state) {
                        return const ExamplePageB('page3');
                      },
                      routes: [
                        FmaStatefulShellRoute(
                          description: 'This is a StatefulShellRoute',
                          builder: (BuildContext context, GoRouterState state,
                              Widget child) {
                            return Scaffold(
                              appBar: AppBar(title: const Text('App Shell')),
                              body: Center(
                                child: child,
                              ),
                            );
                          },
                          branches: [
                            FmaStatefulShellBranch(
                              description: 'This is a StatefulShellBranch',
                              routes: [
                                FmaGoRoute(
                                  description: 'This is a GoRoute from branch',
                                  path: 'page4',
                                  builder: (BuildContext context,
                                      GoRouterState state) {
                                    return const ExamplePageA('page4');
                                  },
                                ),
                                FmaGoRoute(
                                    description:
                                        'This is a GoRoute from branch',
                                    path: 'page5',
                                    builder: (BuildContext context,
                                        GoRouterState state) {
                                      return const ExamplePageA('page5');
                                    },
                                    routes: [
                                      FmaGoRoute(
                                          description:
                                              'This is a GoRoute from page5',
                                          path: 'page6',
                                          builder: (BuildContext context,
                                              GoRouterState state) {
                                            return const ExamplePageA('page6');
                                          },
                                          routes: [
                                            FmaGoRoute(
                                              description:
                                                  'This is a GoRoute from page6',
                                              path: 'page7',
                                              builder: (BuildContext context,
                                                  GoRouterState state) {
                                                return const ExamplePageA(
                                                    'page7');
                                              },
                                            ),
                                          ]),
                                      FmaGoRoute(
                                        description:
                                            'This is a GoRoute from page5',
                                        path: 'page8',
                                        builder: (BuildContext context,
                                            GoRouterState state) {
                                          return const ExamplePageA('page8');
                                        },
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                          navigatorContainerBuilder: (BuildContext context,
                              StatefulNavigationShell navigationShell,
                              List<Widget> children) {
                            return Scaffold(
                              appBar: AppBar(title: const Text('App Shell')),
                              body: Center(
                                child: navigationShell,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ]),
        ],
      ),
    ],
  ),
);

// This is host application
class MyApp extends MicroHostStatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: fmaGoRouter.goRouter,
    );
  }

  // Register all MicroAppPages from GoRouter
  @override
  List<MicroAppPage> get pages => fmaGoRouter.microPages;

  // Register micro app name from GoRouter
  @override
  String get name => fmaGoRouter.name;

  // Register micro app description from GoRouter
  @override
  String get description => fmaGoRouter.description ?? '';

  @override
  List<MicroApp> get initialMicroApps => [];
}

class BaseHomePage extends StatefulWidget {
  const BaseHomePage({Key? key}) : super(key: key);

  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  @override
  void initState() {
    super.initState();
    MicroBoard.showButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: const Text('Open Page with id 42'),
              onPressed: () {
                context.go('/page_with_id/42');
              },
            ),
            ElevatedButton(
              child: const Text('Open Page 1'),
              onPressed: () {
                context.go('/page1');
              },
            ),
            ElevatedButton(
              child: const Text('Open Page 2'),
              onPressed: () {
                context.go('/page2');
              },
            ),
            ElevatedButton(
              child: const Text('Open Page 3'),
              onPressed: () {
                context.go('/page2/page3');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExamplePageA extends StatelessWidget {
  final String pageName;

  const ExamplePageA(this.pageName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
      body: Center(
        child: Text(pageName),
      ),
    );
  }
}

class ExamplePageB extends StatelessWidget {
  final String pageName;

  const ExamplePageB(this.pageName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
      body: Center(
        child: Text(pageName),
      ),
    );
  }
}
