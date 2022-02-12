import 'package:flutter/material.dart';
import 'package:flutter_micro_app/src/controllers/app_event/micro_app_event_controller.dart';
import 'package:flutter_micro_app/src/entities/events/micro_app_event.dart';
import 'package:flutter_micro_app/src/entities/events/micro_app_event_handler.dart';
import 'package:flutter_micro_app/src/utils/mixins/handler_register_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    MicroAppEventController().unregisterAllHandlers();
  });

  testWidgets(
      'Deve armazenar o handler no State e registrar o handler no Gerenciador de eventos'
      ' quando o widget for montado', (tester) async {
    // arrange
    final key = GlobalKey<MyWidgetState>();
    final myWidget = MyWidget(key: key);

    // act
    await tester.pumpWidget(MaterialApp(home: myWidget));

    // assert
    expect(key.currentState?.eventHandlers.length, equals(1));
    expect(MicroAppEventController().handlers.length, equals(1));
  });

  testWidgets(
      'Deve desregistrar os handlers quando o widget for destruido(dispose)',
      (tester) async {
    // arramge
    final key = GlobalKey<MyWidgetState>();
    Widget myWidget = MyWidget(key: key);

    //act
    await tester.pumpWidget(MaterialApp(home: myWidget));

    // assert
    expect(key.currentState?.eventHandlers.length, equals(1));
    expect(MicroAppEventController().handlers.length, equals(1));

    // act
    var allHandlersInState = key.currentState?.eventHandlers;
    await tester.pumpWidget(MaterialApp(home: Container()));

    // assert
    expect(allHandlersInState?.length, equals(0));
    expect(MicroAppEventController().handlers.length, equals(0));
  });

  testWidgets(
      'Deve armazenar todos handlers no State e registrar o handler no Gerenciador de eventos'
      ' quando o widget for montado', (tester) async {
    // arrange
    final key = GlobalKey<MyWidgetState2>();
    final myWidget = MyWidget2(key: key);

    // act
    await tester.pumpWidget(MaterialApp(home: myWidget));

    // assert
    expect(key.currentState?.eventHandlers.length, equals(2));
    expect(MicroAppEventController().handlers.length, equals(2));
  });

  testWidgets(
      'Deve desregistrar todos os handlers quando o widget for destruido(dispose)',
      (tester) async {
    // arrange
    final key = GlobalKey<MyWidgetState2>();
    Widget myWidget = MyWidget2(key: key);

    // act
    await tester.pumpWidget(MaterialApp(home: myWidget));

    // assert
    expect(key.currentState?.eventHandlers.length, equals(2));
    expect(MicroAppEventController().handlers.length, equals(2));

    // act
    var allHandlersInState = key.currentState?.eventHandlers;
    await tester.pumpWidget(MaterialApp(home: Container()));

    // assert
    expect(allHandlersInState?.length, equals(0));
    expect(MicroAppEventController().handlers.length, equals(0));
  });

  testWidgets('Deve disparar o handlers registrado', (tester) async {
    // arrange
    final key = GlobalKey<MyWidgetState>();
    final myWidget = MyWidget(key: key);

    // act
    await tester.pumpWidget(MaterialApp(home: myWidget));
    MicroAppEventController.instance
        .emit(MicroAppEvent<int>(name: 'name', payload: 42));
    await tester.pump();

    // assert
    expect(key.currentState?.count, equals(42));
    expect(key.currentState?.eventHandlers.length, equals(1));
    expect(MicroAppEventController().handlers.length, equals(1));
  });

  testWidgets(
      'Não deve disparar o handler que foi registrado'
      ' quando o widget for destruido(dispose)', (tester) async {
    // arrange
    final key = GlobalKey<MyWidgetState>();
    final myWidget = MyWidget(key: key);

    // act
    await tester.pumpWidget(MaterialApp(home: myWidget));
    await tester.pumpWidget(MaterialApp(home: Container()));
    MicroAppEventController.instance
        .emit(MicroAppEvent<int>(name: 'name', payload: 42));
    await tester.pump();

    // assert
    expect(key.currentState?.count, equals(null));
  });
}

// fixtures
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> with HandlerRegisterMixin {
  int count = 0;

  @override
  void initState() {
    registerEventHandler(MicroAppEventHandler<int>((event) {
      count = event.cast();
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyWidget2 extends StatefulWidget {
  const MyWidget2({Key? key}) : super(key: key);

  @override
  MyWidgetState2 createState() => MyWidgetState2();
}

class MyWidgetState2 extends State<MyWidget2> with HandlerRegisterMixin {
  int count = 0;

  @override
  void initState() {
    registerEventHandler(MicroAppEventHandler<String>((event) {
      count++;
    }));
    registerEventHandler(MicroAppEventHandler<String>((event) {
      count++;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
