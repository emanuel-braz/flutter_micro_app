
### A package to speed up the creation of micro frontend(or independent features) structure in Flutter applications (beta version)
<br>

![Screen Shot 2022-02-03 at 00 32 35](https://user-images.githubusercontent.com/3827308/152278448-3c63a692-f390-4377-964b-6f2c447c0a70.png)


### Navigation between pages
#### Use [NavigatorInstance] to navigate between pages
```dart
NavigatorInstance.pop();
NavigatorInstance.pushNamed();
NavigatorInstance.pushNamedNative();
NavigatorInstance.pushReplacementNamed();
NavigatorInstance ...
```

### Open native (Android/iOS) pages, in this way
#### It needs native implementation, you can see an example inside android folder

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
### Define micro app configurations and contracts

#### Configure the preferences (optional)
```dart
  MicroAppPreferences.update(
    MicroAppConfig(
      nativeEventsEnabled: true, // If you want to dispatch and listen to events between native(Android/iOS) [default = false]
      pathSeparator: MicroAppPathSeparator.slash // It joins the routes segments using slash "/" automatically
    )
  );
```

### Register all routes
> This is just a suggestion of routing strategy (Optional)
It's important that all routes are availble out of the projects, avoiding dependencies between micro apps.
Create all routes inside a new package, and import it in any project as a dependency. This will make possible to open routes from anywhere in a easy and transparent way.  
  
Create the routing package: `flutter create template=package micro_routes` 

```dart 
// Export all routes
class Application1Routes extends MicroAppRoutes {
  @override
  MicroAppBaseRoute get baseRoute => MicroAppBaseRoute('application1');
  String get page1 => baseRoute.path('page1');
  String get page2 => baseRoute.path('page2', ['segment1', 'segment2']);
}
```
  

#### For example, you can open a page that is inside other MicroApp, in this way:
```dart
NavigatorInstance.pushNamed(OtherMicroAppRoutes().specificPage);
NavigatorInstance.pushNamed(Application1Routes().page1);
```



### Expose all pages throuth a contract `MicroApp` (Inside external projects or features folder)
```dart
import 'package:micro_routes/exports.dart';

class Application1MicroApp extends MicroApp with Application1Routes {

  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(name: baseRoute.name, builder: (context, arguments) => const Initial()),
        MicroAppPage(name: page1, builder: (context, arguments) => const Page1()),
        MicroAppPage(name: page2, builder: (context, arguments) {
            final page2Params.fromMap(arguments);
            return Page2(params: page2Params);
        }),
      ];
}
```

### Initialize the host, registering all micro apps
- MicroHost is also a MicroApp, so you can register pages here too.
- MyApp needs to extends MicroHostStatelessWidget or MicroHostStatefulWidget
- The MicroHost is the root widget, and it has all MicroApps, and the MicroApps has all Micro Pages.

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
      initialRoute: baseRoute.name,
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
        MicroAppPage(name: baseRoute.name, builder: (_, __) => const HostHomePage())
      ];

  // Register all [MicroApp]s here
  @override
  List<MicroApp> get microApps => [MicroApplication1(), MicroApplication2()];
}
```

---
### Handling micro apps events

#### Dispatching events
```dart
// dispatching in channel "user_auth", only
MicroAppEventController()
    .emit(const MicroAppEvent(
        name: 'my_event',
        payload: {'data': 'lorem ipsum'},
        channels: ['user_auth'])
    );
```

#### Listen to events (MicroApp)s
```dart
// It listen to all events
@override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((event) => logger.d([ event.name, event.payload]));

// It listen to events with id equals 123, only!
@override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((event) {
        logger.d([ event.name, event.payload]);
      }, id: '123');

// It listen to events with channels "chatbot" and "user_auth"
@override
  MicroAppEventHandler? get microAppEventHandler =>
      MicroAppEventHandler((event) {
        // User auth feature, asked to show a popup :)
        myController.showDialog(event.payload);
      }, channels: ['chatbot', 'user_auth']);
```
#### Managing events
```dart
MicroAppEventController().unregisterHandler(id: '123');
MicroAppEventController().unregisterHandler(channels: ['user_auth']);
MicroAppEventController().pauseAllHandlers();
MicroAppEventController().resumeAllHandlers();
MicroAppEventController().unregisterAllHandlers();
```

### Initiating an event subscription anywhere in the application (inside a StatefulWidget, for example)
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
    MicroAppEventController().unregisterSubscription(id: '1234');
    super.dispose();
}
```
---

### Overriding onGenerateRoute method

If it fails to get a page route, ask for native(Android/iOS) to open the page
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
### The following table shows how Dart values are received on the platform side and vice versa

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
