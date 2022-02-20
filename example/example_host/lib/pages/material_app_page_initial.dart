import 'package:example_routes/routes/application1_routes.dart';
import 'package:example_routes/routes/application2_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class MaterialAppPageInitial extends StatefulWidget {
  const MaterialAppPageInitial({Key? key}) : super(key: key);

  @override
  State<MaterialAppPageInitial> createState() => _MaterialAppPageInitialState();
}

class _MaterialAppPageInitialState extends State<MaterialAppPageInitial>
    with HandlerRegisterMixin {
  int count = 0;

  @override
  List<MicroAppEventHandler> get eventHandlers => [];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Page'),
        leading: IconButton(
            onPressed: () {
              //! Because of MaterialApp above this widget, it need to call the [NativeInstance] singleton
              NavigatorInstance.pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        color: Colors.green,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: const Text('Show snackbar'),
                onPressed: () {
                  MicroAppEventController().emit(
                    MicroAppEvent(
                      name: 'show_snackbar',
                      payload: 'Hello World!',
                      channels: const ['show_snackbar'],
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Emit "my_event"'),
                onPressed: () async {
                  final result = await MicroAppEventController()
                      .emit(MicroAppEvent<Map<String, dynamic>>(
                        name: 'my_event',
                        payload: const {'data': 'lorem ipsum'},
                        channels: const ['abc'],
                      ))
                      .getFirstResult();

                  logger.d(result);
                },
              ),
              ElevatedButton(
                child: const Text('Unregister events handler with (id=123)'),
                onPressed: () {
                  MicroAppEventController().unregisterHandler(id: '123');
                },
              ),
              ElevatedButton(
                child: const Text(
                    'Unregister event handlers with (channel="abc")'),
                onPressed: () {
                  MicroAppEventController()
                      .unregisterHandler(channels: ['abc']);
                },
              ),
              ElevatedButton(
                child: const Text('Pause All event handlers '),
                onPressed: () {
                  MicroAppEventController().pauseAllHandlers();
                },
              ),
              ElevatedButton(
                child: const Text('Resume All event handlers '),
                onPressed: () {
                  MicroAppEventController().resumeAllHandlers();
                },
              ),
              ElevatedButton(
                child: const Text('Unregister All event handlers'),
                onPressed: () {
                  MicroAppEventController().unregisterAllHandlers();
                },
              ),
              ElevatedButton(
                child: const Text('Native app requests Flutter to open Page2'),
                onPressed: () {
                  context.maNav.pushNamedNative(Application2Routes().page2,
                      arguments: 'my arguments');
                },
              ),
              ElevatedButton(
                child: const Text(
                    'Native responses is "true" after "dispose" a page'),
                onPressed: () async {
                  final isValidEmail = await context.maNav
                      .pushNamedNative<bool>('emailValidator',
                          arguments: 'validateEmail:lorem@ipsum.com');
                  logger.d(
                      'Native says email lorem@ipsum.com is a ${isValidEmail ?? false ? 'valid' : 'invalid'} email');
                },
              ),
              ElevatedButton(
                child: const Text('Try open a page that only exists in Native'),
                onPressed: () {
                  // If `onGenerateRoute.routeNativeOnError` is enabled, when there is no flutter page registered,
                  // it will try to open the page in Native(Android/iOS) automatically
                  context.maNav.pushNamed('only_native_page',
                      arguments: 'some_arguments');
                },
              ),
              ElevatedButton(
                child: const Text('Try open Page - not exists'),
                onPressed: () {
                  context.maNav.pushNamed(Application1Routes()
                      .pageExample); // There is no [pageExample] inside current MaterialApp
                },
              ),
              MicroAppWidgetBuilder(
                  initialData: MicroAppEvent(name: 'my_event', payload: 0),
                  channels: const ['widget_channel'],
                  builder: (context, eventSnapshot) {
                    if (eventSnapshot.hasError) return const Text('Error');
                    return ElevatedButton(
                      child: Text(
                        'This is a MicroAppWidgetBuilder / count = ${eventSnapshot.data?.payload}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        MicroAppEventController().emit(MicroAppEvent<int>(
                            name: 'my_event',
                            payload: ++count,
                            channels: const ['widget_channel']));
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
