import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('[MicroAppWidgetBuilder:tipagem]', () {
    testWidgets('Deve encontrar o widget com tipagem dynamic, sem erros',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MicroAppWidgetBuilder(
            initialData: MicroAppEvent(name: 'my_event'),
            channels: const ['widget_channel'],
            builder: (context, eventSnapshot) {
              if (eventSnapshot.hasError) return const Text('Error');
              return Text('Widget Payload: ${eventSnapshot.data?.payload}');
            }),
      ));

      final microAppWidgetBuilder = find.byType(MicroAppWidgetBuilder);
      expect(microAppWidgetBuilder, findsOneWidget);
    });

    testWidgets(
        'Deve encontrar o widget com tipagem String, ao informar um payload inicial do tipo String, via inferencia de tipo',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MicroAppWidgetBuilder(
            initialData: MicroAppEvent(name: 'my_event', payload: ''),
            channels: const ['widget_channel'],
            builder: (context, eventSnapshot) {
              if (eventSnapshot.hasError) return const Text('Error');
              return Text('Widget Payload: ${eventSnapshot.data?.payload}');
            }),
      ));

      final microAppWidgetBuilder = find.byType(MicroAppWidgetBuilder<String>);
      expect(microAppWidgetBuilder, findsOneWidget);
    });

    testWidgets(
        'Deve encontrar o widget com tipagem String, ao definir initalData como MicroAppEvent<String>',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MicroAppWidgetBuilder(
            initialData: MicroAppEvent<String>(name: 'my_event'),
            channels: const ['widget_channel'],
            builder: (context, eventSnapshot) {
              if (eventSnapshot.hasError) return const Text('Error');
              return Text('Widget Payload: ${eventSnapshot.data?.payload}');
            }),
      ));

      final microAppWidgetBuilder = find.byType(MicroAppWidgetBuilder<String>);
      expect(microAppWidgetBuilder, findsOneWidget);
    });

    testWidgets(
        'Deve encontrar o widget com tipagem String, ao criar o widget com generic String [MicroAppWidgetBuilder<String>]',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MicroAppWidgetBuilder<String>(
            initialData: MicroAppEvent(name: 'my_event'),
            channels: const ['widget_channel'],
            builder: (context, eventSnapshot) {
              if (eventSnapshot.hasError) return const Text('Error');
              return Text('Widget Payload: ${eventSnapshot.data?.payload}');
            }),
      ));

      final microAppWidgetBuilder = find.byType(MicroAppWidgetBuilder<String>);
      expect(microAppWidgetBuilder, findsOneWidget);
    });
  });

  group('[MicroAppWidgetBuilder]', () {
    testWidgets(
        'Deve inicializar o texto do widget, com o valor "0" quando o initialData tiver o payload com o valor "0"',
        (WidgetTester tester) async {
      // arrange
      int count = 0;

      // act
      await tester.pumpWidget(MaterialApp(
        home: MicroAppWidgetBuilder<int>(
            initialData: MicroAppEvent(name: 'my_event', payload: count),
            channels: const ['widget_channel'],
            builder: (context, eventSnapshot) {
              if (eventSnapshot.hasError) return const Text('Error');
              return Text('${eventSnapshot.data?.payload}');
            }),
      ));
      final widgetValue = find.text('0');

      // assert
      expect(widgetValue, findsOneWidget);
    });

    group('Deve mudar o valor do texto do widget para 1,', () {
      testWidgets('ao disparar evento do tipo int e payload com valor igual 1',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const [],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        final widgetValue0 = find.text('0');

        // assert
        expect(widgetValue0, findsOneWidget);

        MicroAppEventController()
            .emit(MicroAppEvent<int>(name: 'name', payload: ++count));

        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        final widgetValue0Again = find.text('0');
        final widgetValue1 = find.text('1');

        expect(widgetValue1, findsOneWidget);
        expect(widgetValue0Again, findsNothing);
      });

      testWidgets(
          'ao disparar evento do tipo int e payload com valor igual 1, e channel compativel',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const ['channel1'],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<int>(
            name: 'name', payload: ++count, channels: const ['channel1']));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsOneWidget);
      });

      testWidgets(
          'ao disparar evento do tipo int e payload com valor igual 1, e channel do evento com "channel1" e channel do widget vazio',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const [],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<int>(
            name: 'name', payload: ++count, channels: const ['channel1']));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsOneWidget);
      });

      testWidgets(
          'ao disparar evento do tipo int e payload com valor igual 1, e channel vazio para ambos, evento e widget',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const [],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<int>(
            name: 'name', payload: ++count, channels: const []));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsOneWidget);
      });
    });

    group('Não deve mudar o valor do texto do widget para 1,', () {
      testWidgets(
          'ao disparar evento do tipo int e payload com valor igual 1, e channel vazio, quando o widget tiver channel que não está no evento',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const ['channel1'],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController()
            .emit(MicroAppEvent<int>(name: 'name', payload: ++count));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsNothing);
      });

      testWidgets(
          'ao disparar evento do tipo int e payload com valor igual 1, e channel diferente do channel do widget',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const ['channel1'],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<int>(
            name: 'name', payload: ++count, channels: const ['channel2']));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsNothing);
      });

      testWidgets(
          'ao disparar evento do tipo String e payload com valor igual "1", com o mesmo channel do widget, mas com tipos diferentes (widget<int>)',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const ['channel1'],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<String>(
            name: 'name', payload: '${++count}', channels: const ['channel1']));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsNothing);
      });

      testWidgets(
          'ao disparar evento do tipo String e payload com valor igual "1", quando o widget for do tipo int e não tiver registrado para nenhum channel',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const [],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<String>(
            name: 'name', payload: '${++count}', channels: const ['channel1']));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsNothing);
      });

      testWidgets(
          'ao disparar evento do tipo String e payload com valor igual "1", quando o widget for do tipo int e ambos não tiver channels',
          (WidgetTester tester) async {
        // arrange
        int count = 0;

        // act
        await tester.pumpWidget(MaterialApp(
          home: MicroAppWidgetBuilder<int>(
              initialData: MicroAppEvent(name: 'my_event', payload: count),
              channels: const [],
              builder: (context, eventSnapshot) {
                if (eventSnapshot.hasError) return const Text('Error');
                return Text('${eventSnapshot.data?.payload}');
              }),
        ));

        // assert
        MicroAppEventController().emit(MicroAppEvent<String>(
            name: 'name', payload: '${++count}', channels: const []));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final widgetValue1 = find.text('1');
        expect(widgetValue1, findsNothing);
      });
    });

    testWidgets(
        'Deve mudar o valor do texto do widget para 3, ao disparar 3x o evento do tipo String e payload com valor igual "1,2,3", quando o widget for do tipo String',
        (WidgetTester tester) async {
      // arrange
      int count = 0;

      // act
      await tester.pumpWidget(MaterialApp(
        home: MicroAppWidgetBuilder<String>(
            initialData: MicroAppEvent(name: 'my_event', payload: '$count'),
            channels: const [],
            builder: (context, eventSnapshot) {
              if (eventSnapshot.hasError) return const Text('Error');
              return Text('${eventSnapshot.data?.payload}');
            }),
      ));

      // assert
      MicroAppEventController()
          .emit(MicroAppEvent<String>(name: 'name', payload: '${++count}'));
      MicroAppEventController()
          .emit(MicroAppEvent<String>(name: 'name', payload: '${++count}'));
      MicroAppEventController()
          .emit(MicroAppEvent<String>(name: 'name', payload: '${++count}'));

      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      final widgetValue3 = find.text('3');
      expect(widgetValue3, findsOneWidget);
    });
  });
}
