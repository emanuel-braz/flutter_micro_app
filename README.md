
### A package to speed up the creation of micro apps structure in Flutter applications (beta version)
> Monolithic distribution with multiplatform independent components development, inspired in frameworks such as Single SPA and Systemjs.

[![Pub Version](https://img.shields.io/pub/v/flutter_micro_app?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/flutter_micro_app) 
![CI](https://github.com/emanuel-braz/flutter_micro_app/actions/workflows/analyze.yml/badge.svg)
![license](https://img.shields.io/github/license/emanuel-braz/flutter_micro_app)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
<br>

![Screen Shot 2022-02-03 at 00 32 35](https://user-images.githubusercontent.com/3827308/152278448-3c63a692-f390-4377-964b-6f2c447c0a70.png)


### ⛵️ Navigation between pages
#### Use [NavigatorInstance] to navigate between pages
```dart
NavigatorInstance.pop();
NavigatorInstance.pushNamed();
NavigatorInstance.pushNamedNative();
NavigatorInstance.pushReplacementNamed();
NavigatorInstance ...
```

### 📲 Open native (Android/iOS) pages, in this way
#### It needs native implementation, you can see an example inside Android directory | coming soon, examples and modules to iOS, Desktop and Web, too.

```dart
// If not implemented, always return null
final isValidEmail = await NavigatorInstance.pushNamedNative<bool>(
    'emailValidator',
    arguments: 'validateEmail:lorem@ipsum.com'
);
print('Email is valid: $isValidEmail');
```

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
### ⚙️ Define micro app configurations and contracts

#### Configure the preferences (optional)
```dart
  MicroAppPreferences.update(
    MicroAppConfig(
      nativeEventsEnabled: true, // If you want to dispatch and listen to events between native(Android/iOS) [default = false]
      nativeNavigationCommandEnabled: true,
      nativeNavigationLogEnabled: true,
      pathSeparator: MicroAppPathSeparator.slash // It joins the routes segments using slash "/" automatically
      pageTransitionType: MicroPageTransitionType.platform // Cupetino for iOS, Material for others
    )
  );
```

### 🗺 Register all routes
> This is just a suggestion of routing strategy (Optional)
It's important that all routes are availble out of the projects, avoiding dependencies between micro apps.
Create all routes inside a new package, and import it in any project as a dependency. This will make possible to open routes from anywhere in a easy and transparent way.  
  
Create the routing package: `flutter create --template=package micro_routes` 

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
  

#### For example, you can open a page that is inside other MicroApp, in this way:
```dart
NavigatorInstance.pushNamed(OtherMicroAppRoutes().specificPage);
NavigatorInstance.pushNamed(Application1Routes().page1);
```



### 🤝 Expose all pages throuth a contract `MicroApp` (Inside external projects or features folder)
```dart
import 'package:micro_routes/exports.dart';

class Application1MicroApp extends MicroApp with Application1Routes {

  @override
  List<MicroAppPage> get pages => [

        MicroAppPage(
          route: baseRoute.route, 
          pageBuilder: PageBuilder(
            builder: (context, settings) => const Initial(),
            transitionType: MicroPageTransitionType.slideZoomUp
          ),
        ),

        MicroAppPage(
          route: page1, 
          pageBuilder: PageBuilder(
            builder:  (context, settings) => const Page1()
          )
        ),

        MicroAppPage(
          route: page2, 
          pageBuilder: PageBuilder(
          builder: (context, settings) {
            final page2Params.fromMap(settings.arguments);
            return Page2(params: page2Params);
          }
        )),
      ];
}
```

### 🚀 Initialize the host, registering all micro apps
- MicroHost is also a MicroApp, so you can register pages here too.
- MyApp needs to extends MicroHostStatelessWidget or MicroHostStatefulWidget
- The MicroHost is the root widget, and it has all MicroApps, and the MicroApps has all Micro Pages and associated MicroRoutes.

```dart
void main() {
    runApp(MyApp());
}

class MyApp extends MicroHostStatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: NavigatorInstance.navigatorKey, // Required
      onGenerateRoute: onGenerateRoute, // [onGenerateRoute] this is created automatically, so just use it, or override it, if needed.
      initialRoute: baseRoute.route,
      navigatorObservers: [
        NavigatorInstance // Add NavigatorInstance here, if you want to get didPop, didReplace and didPush events
      ],
    );
  }

  // Base route of host application
  @override
  MicroAppBaseRoute get baseRoute => MicroAppBaseRoute('/');

  // Register all root [MicroAppPage]s here
  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
          name: baseRoute.route, 
          pageBuilder: PageBuilder(
            builder: (_, __) => const HostHomePage()
        ))
      ];

  // Register all [MicroApp]s here
  @override
  List<MicroApp> get microApps => [MicroApplication1(), MicroApplication2()];
}
```

---
### 🤲 Handling micro apps events

#### 🗣 Dispatches events to all handlers that listen to channels 'user_auth' and 'chatbot'
```dart
MicroAppEventController()
    .emit(const MicroAppEvent<Map<String, dynamic>>(
        name: 'my_event',
        payload: {'data': 'lorem ipsum'},
        channels: ['user_auth', 'chatbot'])
    );
```

#### 🗣 Dispatches events directly to handler with id = '0001' (only)
```dart
MicroAppEventController()
    .emit(const MicroAppEvent(
        name: 'my_event',
        payload: {},
        id: '0001')
    );
```

#### 🗣 Dispatches events to handlers that listen to String event type
```dart
MicroAppEventController()
    .emit<String>(const MicroAppEvent(
        name: 'my_event',
        payload: 'some string here')
    );
```

#### 🗣 Dispatches events to handlers that listen to String event type, and channels 'user_auth' and 'wellcome'
```dart
MicroAppEventController()
    .emit<String>(const MicroAppEvent<String>(
        name: 'my_event',
        payload: 'some string here'),
        channels: ['user_auth', 'wellcome']
    );
```

> **Note**
> Use Json String for agnostic platform purposes, or HashMap for Kotlin, Dictionary for Swift or java.util.HashMap for Java

<details open>
<summary style="font-size:14px"> Dispatching event from native, using Json</summary>

```json
{
 "name": "", // Required
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

#### 🦻 Listen to events (MicroApp)s
`MicroApp` has a getter method that must be overwritten, it's called `microAppEventHandler`

Some example scenarios:  
```dart
// It listen to all events
@override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((event) => logger.d([ event.name, event.payload]));

// It listen to events with channels "chatbot" and "user_auth"
@override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((event) {
        // User auth feature, asked to show a popup :)
        myController.showDialog(event.payload);
      }, channels: ['chatbot', 'user_auth']);

// It listen to events with type String (only)
@override
  MicroAppEventHandler<String>? get microAppEventHandler =>
      MicroAppEventHandler((event) {
        // Use .cast() to automatically cast the payload data to String? type
        logger.d(event.cast()); 
      });

// It will be fired for every event, even if the value is the same (distinct = false)
@override
  MicroAppEventHandler<String>? get microAppEventHandler =>
      MicroAppEventHandler((event) {
        logger.d(event.cast()); 
      }, distinct: false);
```

#### Listen to events inside widgets (If need BuildContext)
It can be achieved, registering the event handlers and unregistering them manually, or if you prefer, use a mixin called `HandlerRegisterMixin` to dispose handlers automatically when widget is disposed

**Using mixin** `HandlerRegisterMixin` **example:**
```dart
class MyWidgetState extends State<MyWidget> with HandlerRegisterMixin {

   @override
  List<MicroAppEventHandler> get eventHandlers => [
    MicroAppEventHandler<String>((event) {count++;})
  ];

  @override
  void initState() {
    registerEventHandler(MicroAppEventHandler<String>((event) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(event.cast()),
      ));
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

### 🦻 Initiating an event subscription anywhere in the application (inside a StatefulWidget, for example)
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

### ⫸ Nested Navigators
It's possible to use a `MicroAppBaseRoute` inside a nested navigator `MicroAppNavigatorWidget`

```dart
final baseRoute = ApplicationRoutes();

MicroAppNavigatorWidget(
    microBaseRoute: baseRoute,
    initialRoute: baseRoute.page1
);

// later, inside [page1]
MicroAppNavigator.getInitialRouteSettings(context) as ScreenArguments;
//or
final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

context.maNav.push(baseRoute.page2);
```

It can be registered inside MicroPages list.
```dart
final routes = ApplicationRoutes();

List<MicroAppPage> get pages => [
  MicroAppPage(
      route: routes.baseRoute.route,
      pageBuilder: PageBuilder(
        builder: (context, arguments) => 
          MicroAppNavigatorWidget(
            microBaseRoute: baseRoute,
            initialRoute: Application2Routes().page1)
          )
      )
]
```

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

## 👨‍💻👨‍💻  Contributing
#### Contributions of any kind are welcome!