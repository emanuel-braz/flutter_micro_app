
### A package to speed up the creation of micro apps structure in Flutter applications
> Monolithic distribution with independent multiplatform development, inspired in frameworks such as Single SPA, using Event Driven Architecture.

[![Pub Version](https://img.shields.io/pub/v/flutter_micro_app?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/flutter_micro_app) 
![CI](https://github.com/emanuel-braz/flutter_micro_app/actions/workflows/analyze.yml/badge.svg)
![license](https://img.shields.io/github/license/emanuel-braz/flutter_micro_app)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
<br>

![Screen Shot 2022-02-03 at 00 32 35](https://user-images.githubusercontent.com/3827308/152278448-3c63a692-f390-4377-964b-6f2c447c0a70.png)

---

### ⚙️ Define micro app configurations and contracts

#### Configure the preferences (optional)
```dart
  MicroAppPreferences.update(
    MicroAppConfig(
      nativeEventsEnabled: true, // If you want to dispatch and listen to events between native(Android/iOS) [default = false]
      nativeNavigationCommandEnabled: true,
      nativeNavigationLogEnabled: true,
      pathSeparator: MicroAppPathSeparator.slash // It joins the routes segments using slash "/" automatically

      // The [MicroPageTransitionType.platform] is a dynamic transition type, 
      // for iOS it will use Cupertino, and for others it will use Material.
      pageTransitionType: MicroPageTransitionType.platform,

      // When pushing routes, if the route is not registered, this will be triggered,
      // and it will abort the navigation
      // 
      // [onUnknownRoute] will not be dispatched, since the navigation was aborted.
      //
      // To makes this works, do:
      // - Use root navigator(from MaterialApp) call NavigatorInstance.push...() without context, or
      // - Use MicroAppNavigatorWidget as your nested navigators, or
      // - Use RouterGenerator.onGenerateRoute mixin in your custom navigators
      onRouteNotRegistered: (route, {arguments, type, context}) {
        print('[OnRouteNotRegistered] Route not found: $route, $arguments, $type');
      },
    )
  );
```

### 💾 Flutter DevTools: Inspect the app, search for routes and export all routes to an Excel file (.xlsx)
- Use Flutter Devtools in order to inspect the whole application structure and export all routes to an excel file.

<img width="1674" alt="image" src="https://github.com/user-attachments/assets/7f9dcca9-1085-401c-9096-fc03e7ed5563">


```dart

// In order to use GoRouter, you need to add package https://pub.dev/packages/fma_go_router  
 FmaGoRoute(
  description: 'This is a example of GoRouter page',
  path: 'page_with_id/:id',
  parameters: ExamplePageA.new, // If using `.new`, the parameters will be passed automatically, but you can use a String if you want to pass manually
  builder: (context, state) {
    return ExamplePageA(state.pathParameters['id']);
  },
),

or 

MicroAppPage(
  route: '/page2',
  parameters: Page2.new,
  pageBuilder: PageBuilder(
      widgetBuilder: (_, settings) =>
          Page2(title: settings.arguments as String?)),
),
```

---

### 🚀 Initialize the micro host, registering all micro apps
- MyApp(Widget) needs to extends MicroHostStatelessWidget or MicroHostStatefulWidget
- The MicroHost is the root widget, and it has all MicroApps, and the MicroApps has all Micro Pages and associated MicroRoutes.

```dart
void main() {
    runApp(MyApp());
}

class MyApp extends MicroHostStatelessWidget { // Use MicroHostStatelessWidget or MicroHostStatefulWidget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorInstance.navigatorKey, // Required
      onGenerateRoute: onGenerateRoute, // Required - [onGenerateRoute] this is created automatically, so just use it, or override it, if needed.
      initialRoute: '/host_home_page',
      navigatorObservers: [
        NavigatorInstance // [Optional] Add NavigatorInstance here, if you want to get didPop, didReplace and didPush events
      ],
    );
  }

  // Register all Host [MicroAppPage]s here
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
          route:  '/host_home_page', 
          pageBuilder: PageBuilder(
            widgetBuilder: (_, __) => const HostHomePage()
          ),
          description: 'The initial page of the application',
        ),
         MicroAppPage(
          route: '/modal_page',
          pageBuilder: PageBuilder(
            modalBuilder: (settings) => ModalExamplePage(
                title: '${settings.arguments}'), // extends PopupRoute
          ),
          description: 'ModalBuilder can be used to show [PopupRoute]',
        )
      ];

  // Register all [MicroApp]s here
  @override
  List<MicroApp> get initialMicroApps => [MicroApplication1(), MicroApplication2()];
}
```

### You can structure your application in many ways, this is one of the ways I usually use it in my projects.

![supperapp](https://user-images.githubusercontent.com/3827308/184520011-f1ca6d87-0451-46a2-94b8-53ed8cb2b58a.png)


---

### 🤲 Handling micro apps events

<img src="https://user-images.githubusercontent.com/3827308/184520332-2e77b71e-6000-488a-8a97-b2136458fec9.png" width="320" />



#### 🗣 Dispatches events to all handlers that listen to channels 'user_auth'
```dart
MicroAppEventController().emit(
  const MicroAppEvent(
    name: 'my_event',
    channels: ['user_auth'])
  );
```

#### 🗣 Dispatches events to handlers that listen to String event type
```dart
MicroAppEventController().emit<String>(
  const MicroAppEvent(
    name: 'my_event',
    payload: 'some string here')
  );
```

#### 🗣 Dispatches events to handlers that listen to `MyCustomClass` event type, and channels 'user_auth' and 'wellcome'
```dart
MicroAppEventController().emit<MyCustomClass>(
  const MicroAppEvent(
    name: 'my_event',
    payload: MyCustomClass(userName: 'Emanuel Braz'),
    channels: ['user_auth', 'wellcome']
  );
```

> **Note**
> Use Json String for agnostic platform purposes, or HashMap for Kotlin, Dictionary for Swift or java.util.HashMap for Java.

When running javascript, use `JSON.stringify({})`. see [fma_webview_flutter](https://pub.dev/packages/fma_webview_flutter)

<details open>
<summary style="font-size:14px"> Dispatching event using Json.</summary>

```json
{
 "name": "", // Optional
 "payload": {}, // Optional
 "distinct": true, // Optional
 "channels": [], // Optional
 "version": "1.0.0", // Optional
 "datetime": "2020-01-01T00:00:00.000Z" // Optional
}
```
</details>

<details open>
<summary style="font-size:14px"> Dispatching event from native(Android), using Kotlin</summary>

```kotlin
val payload: MutableMap<String, Any> = HashMap()
payload["platform"] = "Android"

val arguments: MutableMap<String, Any> = HashMap()
arguments["name"] = "event_from_native"
arguments["payload"] = payload
arguments["distinct"] = true
arguments["channels"] = listOf("abc", "chatbot")
arguments["version"] = "1.0.0"
arguments["datetime"] = "2020-01-01T00:00:00.000Z"

appEventChannelMessenger.invokeMethod("app_event", arguments)
```
</details>



#### 🌐 It is possible to wait for other micro apps to respond to the event you issued, but make sure someone else will respond to your event, or use `timeout` parameter to set a wait limit time, otherwise you will wait forever 😢 
remember, _with great power comes great responsibility_

`.getFirstResult()` will return the first response(fastest) among all micro apps that eventually can respond to this same event.  

For example, if you request a JWT token to all micro apps(broadcast), the first response(if more than one MA can respond) will end up your request with the resultSucces value or with a resultError, from the fastest micro app.

```dart
  final result = await MicroAppEventController()
    .emit(MicroAppEvent<Map<String, String>>(
      name: 'get_jwt',
      payload: const {'userId': 'ABC123'},
      channels: const ['jwt'],
    )
  ).getFirstResult(); // This will return the first response(fastest) among all micro app that eventually can respond to this same the event

  print(result);
```

Later, when some micro app that is listening to same channel get triggered, it can answer success or error.
```dart
// results success
event.resultSuccess(['success message by Wally West', 'your token, Sir.']);

// results error
event.resultError(['error message by Barry Allen', 'my bad 🤦']);

// Who will respond faster? native? flutter?
// If you don't want to take that risk, just deal with the List<Future> response.
```

**Dealing with errors and timeout:**

`timeout` is an optional parameter, use only if you intends to wait for 
the event to be sent back, otherwise this can throw uncaught timeout exceptions.

If you need an EDA approach, use the `MicroAppEventHandler` as a consumer, in order to get all event dispatched by producers.
```dart
try {
  final result = await MicroAppEventController()
      .emit(
        MicroAppEvent<String>(
          name: 'event_from_flutter',
          payload: 'My payload',
        ),
        timeout: const Duration(seconds: 2)
      )
      .getFirstResult();
  logger.d('Result is: $result');
} on TimeoutException catch (e) {
  logger.e(
      'The native platform did not respond to the request',
      error: e);
} on PlatformException catch (e) {
  logger.e(
      'The native platform respond to the request with some error',
      error: e);
} on Exception {
  logger.e('Generic Error');
}
```
or
```dart
final futures = MicroAppEventController().emit(
  MicroAppEvent(
      name: 'show_snackbar',
      payload: 'Hello World!',
      channels: const ['show_snackbar'],
    ),
    timeout: const Duration(seconds: 3)
  ); 

futures
  .getFirstResult()
  .then((value) => {
    // 2 - this line will be executed later
        logger.d(
            '** { You can capture data asyncronously later } **')
      })
  .catchError((error) async {
  logger.e(
      '** { You can capture errors asyncronously later } **',
      error: error);
  return <dynamic>{};
});

  // 1 - this line will be executed first
logger.d('** { You do not need to wait for a TimeoutException } **');
```

--- 

### 🦻 Listen to events (MicroApps)
Use the mixin `HandlerRegisterMixin` in order to get the method `registerEventHandler`

```dart
class MyMicroApplication extends MicroApp with HandlerRegisterMixin {
  
  MyMicroApplication() {
    // It listen to all events
    // Avoid using such a generic handler, prefer to use handlers by type 
    // and with channels for a granular and specialized treatment
    registerEventHandler(
      MicroAppEventHandler(
        (event) => logger.d([ event.name, event.payload])
      );
    );
  }

}
```

Some example scenarios:  
```dart
// It listen to events with channels "chatbot" and "user_auth"
registerEventHandler(
  MicroAppEventHandler((event) {
    // User auth feature, asked to show a popup :)
    myController.showDialog(event.payload);
  }, channels: ['chatbot', 'user_auth']);
);


// It listen to events with type String (only)
registerEventHandler<String>(
  MicroAppEventHandler((event) {
    // Use .cast() to automatically cast the payload data to String? type
    logger.d(event.cast()); 
  });
);    

// It will be fired for every event, even if the value is the same (distinct = false)
registerEventHandler(
  MicroAppEventHandler((event) {
    logger.d(event.cast()); 
  }, distinct: false);
);   
```

#### Listen to events inside widgets (If need BuildContext or if you need to unregister event handlers automatically)
It can be achieved, registering the event handlers and unregistering them manually, but is advised to use a mixin called `HandlerRegisterStateMixin` to dispose handlers automatically when widget is disposed

**Using mixin** `HandlerRegisterStateMixin` **example:**
```dart
class MyWidgetState extends State<MyWidget> with HandlerRegisterStateMixin {

  @override
  void initState() {
    registerEventHandler(
      MicroAppEventHandler<String>((event) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.cast())));
    }, channels: const ['show_snackbar'], distinct: false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

#### Managing event handlers
```dart
MicroAppEventController().unregisterHandler(id: '123');
MicroAppEventController().unregisterHandler(handler: handlerInstance);
MicroAppEventController().unregisterHandler(channels: ['user_auth']);
MicroAppEventController().pauseAllHandlers();
MicroAppEventController().resumeAllHandlers();
MicroAppEventController().unregisterAllHandlers();
```

### 🦻 Initiating an event subscription anywhere in the application
Take care when registering an event handler directly in the controller, as you will need to manually unregister them when they are no longer needed.

Always prefer to use the `HandlerRegisterStateMixin` and `HandlerRegisterMixin` mixins, as they take care to unregister event handlers when they are no longer useful.
#### Using subscription
```dart
final subscription = MicroAppEventController().stream.listen((MicroAppEvent event) {
    logger.d(event);
  });

// later, in dispose method of the widget
@override
void dispose() {
    subscription.cancel();
    super.dispose();
}
```
#### Using handler
```dart
MicroAppEventController().registerHandler(MicroAppEventHandler(id: '1234'));

// later, in dispose method of the widget
@override
void dispose() {
    MicroAppEventController().unregisterHandler(id: '1234');
    super.dispose();
}
```

---

### 🏭 Using the pre-built widget `MicroAppWidgetBuilder` to display data on the screen
It can be used to show visual info on the screen.
In this example, it shows a button and the label changes when user clicks on the button
> ℹ️ When user dispatched an event in the same channel that the widget is listening to, the widget redraw the updated info on the screen.

```dart
MicroAppWidgetBuilder(
  initialData: MicroAppEvent(name: 'my_event', payload: 0),
  channels: const ['widget_channel'],
  builder: (context, eventSnapshot) {
    if (eventSnapshot.hasError) return const Text('Error');
    return ElevatedButton(
      child: Text('Widget count = ${eventSnapshot.data?.payload}'
      ),
      onPressed: () {
        MicroAppEventController().emit(MicroAppEvent<int>(
            name: 'my_event',
            payload: ++count,
            channels: const ['widget_channel']));
      },
    );
  }
)
```

---
### 🤝 Exposing all pages through a contract `MicroApp` or use Go Router(go_router) package with fma_go_router

https://pub.dev/packages/fma_go_router  
https://pub.dev/packages/go_router

```dart
// Using Go Router (Advanced and flexible)
final FmaGoRouter fmaGoRouter = FmaGoRouter(
  name: 'GoRouter Example',
  description: 'This is an example of GoRouter',
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
            description: 'This page has path parameter',
            parameters: ExamplePageA.new,
            path: 'page_with_id/:id',
            builder: (context, state) {
              return ExamplePageA(
                  'page with id = ' + (state.pathParameters['id'] ?? ''));
            },
          ),
          FmaGoRoute(
            description: 'This is the first page',
            path: 'page1',
            parameters: ExamplePageA.new,
            builder: (context, state) {
              return const ExamplePageA('page1');
            },
          ),
        ],
      ),
    ],
  ),
);
```

```dart
// Using MicroApp defaults (Simple and easy to use)
import 'package:micro_routes/exports.dart';

class Application1MicroApp extends MicroApp {

  final routes = Application1Routes();

  @override
  List<MicroAppPage> get pages => [

        MicroAppPage<Initial>(
          description: 'The initial page of the micro app 1',
          route: routes.baseRoute.route, 
          parameters: Initial.new,
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) => const Initial(),
            transitionType: MicroPageTransitionType.slideZoomUp
          ),
        ),

        MicroAppPage<Page1>(
          description: 'Display all buttons of the showcase',
          route: routes.page1, 
          parameters: Page1.new,
          pageBuilder: PageBuilder(
            modalBuilder: (settings) => Page1(), // if Page1 extends PopupRoute, use `modalBuilder`
          )
        ),

        MicroAppPage<Page2>(
          description: 'The page two',
          route: routes.page2, 
          pageBuilder: PageBuilder(
          widgetBuilder: (context, settings) {
            final page2Params.fromMap(settings.arguments);
            return Page2(params: page2Params);
          }
        )),
      ];
}
```

--- 
### 🗺 Create all routes outside the app project
> This is just a suggestion of routing strategy (Optional)
It's important that all routes are availble out of the projects, avoiding dependencies between micro apps.
Create all routes inside a new package, and import it in any project as a dependency. This will make possible to open routes from anywhere in a easy and transparent way.  
  
Create the routing package: `flutter create --template=package micro_routes` 
or keep the routes in common package.

```dart 
// Export all routes
import 'package:flutter_micro_app/flutter_micro_app.dart';

class Application1Routes implements MicroAppBaseRoute {
  @override
  MicroAppRoute get baseRoute => MicroAppRoute('application1');

  String get pageExample => path(['example_page']);
  String get page1 => path(['page1']);
  String get page2 => path(['page2','segment1', 'segment2']);
}
```

---

### ⛵️ Navigation between pages
#### For example, you can open a page that is inside other MicroApp, into the root `Navigator`, in this way(without context):
```dart
NavigatorInstance.pushNamed(Application2Routes().page1);
NavigatorInstance.pushNamed('microapp2/page1');
```

#### or you can use the `context` extension, to get the scoped Navigator [`maNav`]

```dart
context.maNav.pushNamed(Application2Routes().page2);
context.maNav.pushNamed('microapp2/page2');
```

#### or you can use `Navigator.of(context)`, to get scoped Navigator

```dart
Navigator.of(context).pushNamed(Application2Routes().page2);
Navigator.of(context).pushNamed('microapp2/page2');
```

---

### 📲 Open native (Android/iOS) pages, in this way
#### It needs native implementation, you can see an example inside Android directory
Examples and new modules to Android, iOS and Web soon

```dart
// If not implemented, always return null
final isValidEmail = await NavigatorInstance.pushNamedNative<bool>(
    'emailValidator',
    arguments: 'validateEmail:lorem@ipsum.com'
);
print('Email is valid: $isValidEmail');
```

#### Listening to navigation events
```dart
// Listen to all flutter navigation events
NavigatorInstance.eventController.flutterLoggerStream.listen((event) {
    logger.d('[flutter: navigation_log] -> $event');
});

// Listen to all native (Android/iOS) navigation events (if implemented)
NavigatorInstance.eventController.nativeLoggerStream.listen((event) {});

// Listen to all native (Android/iOS) navigation requests (if implemented)
NavigatorInstance.eventController.nativeCommandStream.listen((event) {});
```

---

### 📝 Overriding onGenerateRoute method

If it fails to get a page route, ask for native(Android/iOS/Desktop/Web) to open the page
```dart
  @override
  Route? onGenerateRoute(RouteSettings settings, {bool? routeNativeOnError}) {
    //! If you wish native app receive requests to open routes, IN CASE there
    //! is no route registered in Flutter, please set [routeNativeOnError: true]
    return super.onGenerateRoute(settings, routeNativeOnError: true);
  }
```

If it fails to get a page route, show a default error page
```dart
  @override
  Route? onGenerateRoute(RouteSettings settings, {bool? routeNativeOnError}) {
    
    final pageRoute = super.onGenerateRoute(settings, routeNativeOnError: false);

    if (pageRoute == null) {
       // If pageRoute is null, this route wasn't registered(unavailable)
       return MaterialPageRoute(
           builder: (_) => Scaffold(
                 appBar: AppBar(),
                 body: const Center(
                   child: Text('Page Not Found'),
                 ),
            ));
    }
    return pageRoute;
  }
     
```

---


### ⫸ Nested Navigators
It's possible to use a `MicroAppBaseRoute` inside a nested navigator `MicroAppNavigatorWidget`

**IMPORTANT:** use the `context.maNav` to navigate:
```dart
context.maNav.push(baseRoute.page2);
```

```dart
final baseRoute = ApplicationRoutes();

MicroAppNavigatorWidget(
    microBaseRoute: baseRoute,
    initialRoute: baseRoute.page1
);

// later, inside [page1]
final settings = MicroAppNavigator.getInitialRouteSettings(context);
//or
final settings = context.maNav.getInitialRouteSettings();


//IMPORTANT: use the context to navigate
context.maNav.push(baseRoute.page2);
```

It can be registered inside MicroPages list.
```dart
final routes = ApplicationRoutes();

List<MicroAppPage> get pages => [
  MicroAppPage(
      route: routes.baseRoute.route,
      description: 'The nested navigator',
      pageBuilder: PageBuilder(
        widgetBuilder: (context, arguments) => 
          MicroAppNavigatorWidget(
            microBaseRoute: baseRoute,
            initialRoute: Application2Routes().page1)
          )
      )
]
```



---

### 📊 Micro Board
#### The Micro Board (dashboard) enables you to inspect all micro apps, routes and event handlers.
- Inspect which handler channels are duplicated
- Inspect the types and amount of handlers and their channels per micro app
- Inspect the types and amount of handlers and their channels by Widget
- Inspect orphaned handlers
- Inspect all registered routes from the application

|   |  |
| --- | ---   |
|![Screenshot_1660444694](https://user-images.githubusercontent.com/3827308/184520487-c77a7e09-d525-4eca-b3aa-9ee1fca6c4c2.png)  | ![Screenshot_1660444762](https://user-images.githubusercontent.com/3827308/184520492-28f204e2-3b6b-4644-856e-c11872cbd40f.png) |

**Show Micro Board button (longPress hides the button, and click opens the Micro Board)**  
This will create a draggable floating button, that enables you to open the Micro Board. By default it is not displayed in release mode.
```dart
MicroBoard.showButton();
MicroBoard.hideButton()
```
or
```dart
MicroBoard().showBoard();
```

---

### 🌐 Micro Web (Webview Controllers)
Take a look at https://pub.dev/packages/fma_webview_flutter

<img src="https://user-images.githubusercontent.com/3827308/180587584-e1b4cea3-c92d-45b6-91bc-dbb5e1e74487.png" width="320" />


---

### 📎 The following table shows how Dart values are received on the platform side and vice versa

|Dart	                    |   Kotlin         |    Swift                                   |   Java
|---|---|---|---|
|null	                    |   null           |    nil                                     |   null
|bool	                    |   Boolean        |    NSNumber(value: Bool)                   |   java.lang.Boolean
|int	                    |   Int            |    NSNumber(value: Int32)                  |   java.lang.Integer
|int, if 32 bits not enough	|   Long           |    NSNumber(value: Int)                    |   java.lang.Long
|double	                    |   Double         |    NSNumber(value: Double)                 |   java.lang.Double
|String	                    |   String         |    String                                  |   java.lang.String
|Uint8List	                |   ByteArray      |    FlutterStandardTypedData(bytes: Data)   |   byte[]
|Int32List	                |   IntArray       |    FlutterStandardTypedData(int32: Data)   |   int[]
|Int64List	                |   LongArray      |    FlutterStandardTypedData(int64: Data)   |   long[]
|Float32List	            |   FloatArray     |    FlutterStandardTypedData(float32: Data) |   float[]
|Float64List	            |   DoubleArray    |    FlutterStandardTypedData(float64: Data) |   double[]
|List	                    |   List           |    Array                                   |   java.util.ArrayList
|Map	                    |   HashMap        |    Dictionary                              |   java.util.HashMap
  
<br>  

---

## 👨‍💻👨‍💻  Contributing
#### Contributions of any kind are welcome!
