import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_go_router/fma_go_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  MicroBoard().getMicroBoardApps;

  MicroAppEventController().registerHandler(MicroAppEventHandler<Map>(
    (event) {
      debugPrint('[restart_app] Received event: ${event.payload}');
    },
    channels: const ['restart_app'],
  ));

  runApp(MyApp());
}

final FmaGoRouter fmaGoRouter = FmaGoRouter(
  name: 'Micro Host',
  description: 'This is an example of microapp using GoRouter',
  goRouter: GoRouter(
    navigatorKey: NavigatorInstance.navigatorKey,
    routes: <RouteBase>[
      FmaGoRoute(
        description: 'This is the boot page',
        path: '/',
        parameters: BaseHomePage.new,
        builder: (BuildContext context, GoRouterState state) {
          return const BaseHomePage();
        },
        routes: <RouteBase>[
          FmaGoRoute(
            description: 'This page has parameter',
            path: 'page_with_id/:id',
            parameters: ExamplePageA.new,
            builder: (context, state) {
              return ExamplePageA(
                  'page with id = ' + (state.pathParameters['id'] ?? ''));
            },
          ),
          FmaGoRoute(
            description: 'This page has parameters with group\n'
                'group/:groupId/item/:itemId',
            path: 'group/:groupId/item/:itemId',
            parameters: GroupParams.new,
            builder: (context, state) {
              return ExamplePageA(
                  'page with id = ' + (state.pathParameters['id'] ?? ''));
            },
          ),
          FmaGoRoute(
            description: 'This is the first page',
            path: 'page1',
            parameters: ExamplePageC.new,
            builder: (context, state) {
              final pageName = (state.extra as Map)['pageName'] as String;
              return ExamplePageA(pageName);
            },
          ),
          FmaGoRoute(
              description: 'This is the seconds page',
              path: 'page2',
              name: 'Page 2',
              parameters: 'String name, int age',
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
                      parameters: ExamplePageD.new,
                      builder: (BuildContext context, GoRouterState state) {
                        return const ExamplePageD(
                          pageName: 'page3',
                        );
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
class MyApp extends MicroHostStatelessWidget with HandlerRegisterMixin {
  MyApp({super.key}) {
    registerEventHandler(
      MicroAppEventHandler(
        (event) {
          final name = event.name;

          if (name?.isNotEmpty == true) {
            switch (name) {
              case 'pop':
                fmaGoRouter.goRouter.pop();
                break;
              case 'push':
                final route = event.payload['route'];
                final parameters = event.payload['parameters'];
                fmaGoRouter.goRouter.go(route, extra: parameters);
                break;
            }
          } else {
            final route = event.payload['route'];
            final parameters = event.payload['parameters'];
            fmaGoRouter.goRouter.go(route, extra: parameters);
          }
        },
        channels: const ['navigate'],
        distinct: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: fmaGoRouter.goRouter,
      ),
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
  List<MicroApp> get initialMicroApps => [
        OnboardingMicroApp(),
        UserMicroApp(),
        AuthMicroApp(),
        ChatbotMicroApp(),
      ];
}

class BaseHomePage extends StatefulWidget {
  const BaseHomePage({Key? key}) : super(key: key);

  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage>
    with HandlerRegisterStateMixin {
  @override
  void initState() {
    super.initState();

    MicroBoard.showButton();

    registerEventHandler(
      MicroAppEventHandler(
        (event) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(event.payload.toString()),
            ),
          );
        },
        channels: const ['snackbar', 'auth'],
      ),
    );
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
                context.go('/page1', extra: {'pageName': 'Page 1'});
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

class GroupParams {
  final String groupId;
  final String itemId;

  GroupParams({
    required this.groupId,
    required this.itemId,
  });
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

  const ExamplePageB(this.pageName, {super.key, String? name2});

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

class ExamplePageC extends StatelessWidget {
  final String pageName;

  const ExamplePageC(this.pageName, [String? name2, Key? key])
      : super(key: key);

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

class ExamplePageD extends StatelessWidget {
  final String pageName;

  const ExamplePageD({required this.pageName, String? name2, Key? key})
      : super(key: key);

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

// Do not use Microapp with routes if you are using GoRouter, it's not fully supported. This is just an example to fill the dashboard
class OnboardingMicroApp extends MicroApp {
  @override
  String get name => 'Onboarding MicroApp';

  @override
  String get description => 'This micro app is intended for onboarding users';

  @override
  List<MicroAppPage<Widget>> get pages => [];
}

// Do not use Microapp with routes if you are using GoRouter, it's not fully supported. This is just an example to fill the dashboard
class UserMicroApp extends MicroApp with HandlerRegisterMixin {
  UserMicroApp() {
    registerEventHandler(
      MicroAppEventHandler(
        (event) {},
        channels: const ['get_user', 'update_user', 'delete_user'],
      ),
    );
  }

  @override
  String get name => 'User MicroApp';

  @override
  String get description => 'This micro app is intended for user management';

  @override
  List<MicroAppPage<Widget>> get pages => [
        MicroAppPage(
          name: 'User Profile',
          description: 'This page displays user profile information',
          route: '/user/profile',
          parameters: ExamplePageA.new,
          pageBuilder: PageBuilder(widgetBuilder: (context, settings) {
            final json = settings.arguments as Map;
            final String pageName = json['pageName'];
            return ExamplePageA(pageName);
          }),
        ),
        MicroAppPage(
          name: 'User Settings',
          description: 'This page displays user settings',
          route: '/user/settings',
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) =>
                const ExamplePageA('User Settings'),
          ),
        ),
      ];
}

// Do not use Microapp with routes if you are using GoRouter, it's not fully supported. This is just an example to fill the dashboard
class AuthMicroApp extends MicroApp with HandlerRegisterMixin {
  AuthMicroApp() {
    registerEventHandler(
      MicroAppEventHandler(
        (event) {},
        channels: const ['auth'],
      ),
    );
  }

  @override
  String get name => 'Auth MicroApp';

  @override
  String get description =>
      'This micro app is intended for authentication purposes';

  @override
  List<MicroAppPage<Widget>> get pages => [
        MicroAppPage(
          name: 'Login',
          description: 'This page is for user login',
          route: '/auth/login',
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) => const ExamplePageA('Login'),
          ),
        ),
        MicroAppPage(
          name: 'Register',
          description: 'This page is for user registration',
          route: '/auth/register',
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) =>
                const ExamplePageA('Register'),
          ),
        ),
        MicroAppPage(
          name: 'Forgot Password',
          description: 'This page is for password recovery',
          route: '/auth/forgot-password',
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) =>
                const ExamplePageA('Forgot Password'),
          ),
        ),
      ];
}

// Do not use Microapp with routes if you are using GoRouter, it's not fully supported. This is just an example to fill the dashboard
class ChatbotMicroApp extends MicroApp with HandlerRegisterMixin {
  @override
  String get name => 'Navigator MicroApp';

  @override
  String get description => 'This micro app is intended for navigation events';

  @override
  List<MicroAppPage<Widget>> get pages => [];
}
