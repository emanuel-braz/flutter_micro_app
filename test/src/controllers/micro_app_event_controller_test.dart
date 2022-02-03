import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_test/flutter_test.dart';

/*
  Test descriptions are in Portuguese language
*/

void main() {
  late MicroAppEventController controller;
  late HandlerRegisterHelper registerHelper;

  setUpAll(() {
    MicroAppPreferences.update(MicroAppConfig(
        nativeEventsEnabled: false,
        pathSeparator: MicroAppPathSeparator.slash));
  });

  setUp(() {
    controller = MicroAppEventController.$testOnlyPurpose();
    registerHelper = HandlerRegisterHelper();
  });

  group('[HandlerRegisterHelper]', () {
    test(
        'Quando um evento sem channels for emitido, deve disparar o handler, se handler nao tiver channels definidos',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      const event = MicroAppEvent(name: 'my_event');
      controller.registerHandler(handler);

      // act
      final result = registerHelper.shouldHandleEvents(handler, event);

      // assert
      expect(result, equals(true));
    });

    test(
        'Quando um evento com channels for emitido, deve disparar o handler, se handler nao tiver channels definidos',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      const event = MicroAppEvent(name: 'my_event', channels: ['channel1']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.shouldHandleEvents(handler, event);

      // assert
      expect(result, equals(true));
    });

    test(
        'Quando um evento com channels for emitido, deve disparar o handler, se o handler tiver um channel que exista também no evento',
        () {
      // arrange
      const commonChannel = 'channel2';
      final handler =
          MicroAppEventHandler((event) {}, channels: const [commonChannel]);
      const event = MicroAppEvent(
          name: 'my_event', channels: ['channel1', commonChannel, 'channel3']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.shouldHandleEvents(handler, event);

      // assert
      expect(result, equals(true));
    });

    test(
        'Quando um evento com channels for emitido, Não deve disparar o handler, se handler tiver algum channel, mas que Não seja nenhum dos channels existentes no evento',
        () {
      // arrange
      final handler =
          MicroAppEventHandler((event) {}, channels: const ['channel1']);
      const event =
          MicroAppEvent(name: 'my_event', channels: ['channel2', 'channel3']);

      // act
      controller.registerHandler(handler);

      // act
      final result = registerHelper.shouldHandleEvents(handler, event);

      // assert
      expect(result, equals(false));
    });

    test(
        'Quando o controller emitir um evento com mútiplos channels, deve disparar o handler, se o handler tiver um channel que exista também no evento',
        () {
      // arrange
      final handler =
          MicroAppEventHandler((event) {}, channels: const ['channel1']);
      const event = MicroAppEvent(
          name: 'my_event', channels: ['channel1', 'channel2', 'channel3']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.shouldHandleEvents(handler, event);

      // assert
      expect(result, equals(true));
    });

    test(
        'Quando o controller emitir um evento com um único channel, deve disparar o handler, se o handler tiver múltiplos channels, e pelo menos um, exista também no evento',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {},
          channels: const ['channel1', 'channel2', 'channel3']);
      const event = MicroAppEvent(name: 'my_event', channels: ['channel3']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.shouldHandleEvents(handler, event);

      // assert
      expect(result, equals(true));
    });

    test(
        'Deve desregistrar os dois handlers com o "channel1" e deve permanecer o handler com "channel3" e "channel12", quando desregistrar pelo "channel1"',
        () async {
      // arrange
      final handler1 =
          MicroAppEventHandler((event) {}, channels: const ['channel1']);
      final handler2 = MicroAppEventHandler((event) {},
          channels: const ['channel1', 'channel2']);
      final handler3 =
          MicroAppEventHandler((event) {}, channels: const ['channel2']);
      final handler4 =
          MicroAppEventHandler((event) {}, channels: const ['channel12']);

      controller.registerHandler(handler1);
      controller.registerHandler(handler2);
      controller.registerHandler(handler3);
      controller.registerHandler(handler4);

      await controller.unregisterHandler(channels: ['channel1']);

      // assert
      expect(controller.handlers.entries.length, equals(2));

      final hasHandler1 = controller.hasHandler(channels: ['channel1']);
      final hasHandler2 = controller.hasHandler(channels: ['channel1']);
      final hasHandler3 = controller.hasHandler(channels: ['channel2']);
      final hasHandler4 = controller.hasHandler(channels: ['channel12']);

      expect(controller.handlers.entries.length, equals(2));
      expect(hasHandler1, equals(false));
      expect(hasHandler2, equals(false));
      expect(hasHandler3, equals(true));
      expect(hasHandler4, equals(true));
    });

    test(
        'O handler deve ser encontrado nos registros, caso o channel informado coincidir',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {},
          channels: const ['channel1', 'channel2', 'channel3']);

      final handlerSholdBeFoundInHandlersMap =
          registerHelper.isChannelsIntersection(handler.channels, ['channel2']);

      expect(handlerSholdBeFoundInHandlersMap, equals(true));
    });

    test(
        'O handler deve ser encontrado nos registros, em caso de um ou mais channels coincidirem',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {},
          channels: const ['channel1', 'channel2']);

      final handlerSholdBeFoundInHandlersMap = registerHelper
          .isChannelsIntersection(handler.channels, ['channel2', 'channel1']);

      expect(handlerSholdBeFoundInHandlersMap, equals(true));
    });

    test(
        'O handler deve ser encontrado nos registros, em caso de um channel coincidir',
        () {
      // arrange
      final handler =
          MicroAppEventHandler((event) {}, channels: const ['channel1']);

      final handlerSholdBeFoundInHandlersMap = registerHelper
          .isChannelsIntersection(handler.channels, ['channel2', 'channel1']);

      expect(handlerSholdBeFoundInHandlersMap, equals(true));
    });

    test(
        'O handler Não deve ser encontrado nos registros, caso a lista de channels esteja vazia',
        () {
      // arrange
      final handler =
          MicroAppEventHandler((event) {}, channels: const ['channel1']);

      final handlerSholdBeFoundInHandlersMap =
          registerHelper.isChannelsIntersection(handler.channels, []);

      expect(handlerSholdBeFoundInHandlersMap, equals(false));
    });

    test(
        'O handler Não deve ser encontrado nos registros, caso a lista de channels dos handlers estejam vazias',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {}, channels: const []);

      final handlerSholdBeFoundInHandlersMap =
          registerHelper.isChannelsIntersection(handler.channels, ['channel1']);

      expect(handlerSholdBeFoundInHandlersMap, equals(false));
    });

    test(
        'O handler Não deve ser encontrado nos registros, caso a lista de channels dos handlers e a lista de channels informados estejam vazias',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {}, channels: const []);

      final handlerSholdBeFoundInHandlersMap =
          registerHelper.isChannelsIntersection(handler.channels, []);

      expect(handlerSholdBeFoundInHandlersMap, equals(false));
    });

    test(
        'O handler Não deve ser encontrado nos registros, caso a lista de channels for nula',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {}, channels: const []);

      final handlerSholdBeFoundInHandlersMap =
          registerHelper.isChannelsIntersection(handler.channels, null);

      expect(handlerSholdBeFoundInHandlersMap, equals(false));
    });

    group('unregisterAllHandlers', () {
      test(
          'Não deve exister qualquer handler em registro, depois de desregistrar todos os handlers',
          () async {
        // arrange
        final handler1 =
            MicroAppEventHandler((event) {}, channels: const [], id: '123456');
        final handler2 =
            MicroAppEventHandler((event) {}, channels: const ['abcdef']);

        // act
        controller.registerHandler(handler1);
        controller.registerHandler(handler2);
        await controller.unregisterAllHandlers();

        // assert
        expect(controller.handlers.entries.length, equals(0));
      });

      test(
          'Não deve ser disparado qualquer evento, depois de desregistrar todos os handlers',
          () async {
        // arrange
        var handler1Dispatched = false;
        final handler1 = MicroAppEventHandler((event) {
          handler1Dispatched = true;
        }, channels: const [], id: '123456');
        final handler2 =
            MicroAppEventHandler((event) {}, channels: const ['abcdef']);
        const event = MicroAppEvent(name: 'my_event', channels: ['channel1']);

        // act
        controller.registerHandler(handler1);
        controller.registerHandler(handler2);
        await controller.unregisterAllHandlers();
        controller.emit(event);
        await Future.delayed(Duration.zero);

        expect(handler1Dispatched, equals(false));
      });
    });
  });

  group('[MicroAppEventController.hasHandler]', () {
    test(
        'Quando handler2 não estiver registrado, ele Não deve ser encontrado nos registros de handlers',
        () {
      const handler1Id = '123456';
      const handler2Id = 'ABC';
      final handler1 =
          MicroAppEventHandler((event) {}, channels: const [], id: handler1Id);
      // final handler2 = MicroAppEventHandler((event) {}, channels: const ['abcdef'], id: handler2Id);

      // act
      controller.registerHandler(handler1);

      expect(controller.hasHandler(id: handler1Id), equals(true));
      expect(controller.hasHandler(id: handler2Id), equals(false));
    });

    test(
        'Quando informado handler1Id = "12" handler2Id = "ABC" e o registro possuir esses ids, deve retornar true para ambos',
        () {
      const handler1Id = '12';
      const handler2Id = 'ABC';
      final handler1 =
          MicroAppEventHandler((event) {}, channels: const [], id: handler1Id);
      final handler2 = MicroAppEventHandler((event) {},
          channels: const ['abcdef'], id: handler2Id);

      // act
      controller.registerHandler(handler1);
      controller.registerHandler(handler2);

      expect(controller.hasHandler(id: handler1Id), equals(true));
      expect(controller.hasHandler(id: handler2Id), equals(true));
    });

    test(
        'Quando informado "channel1" e o registro possuir um ou mais handler com esse channel, deve retornar true',
        () {
      const handler1Id = '123456';
      const handler2Id = 'ABC';
      final handler1 = MicroAppEventHandler((event) {},
          channels: const ['channel1', 'channel2'], id: handler1Id);
      final handler2 = MicroAppEventHandler((event) {},
          channels: const ['channel1'], id: handler2Id);

      // act
      controller.registerHandler(handler1);
      controller.registerHandler(handler2);
      final hasHandler = controller.hasHandler(channels: ['channel1']);

      expect(hasHandler, equals(true));
    });
  });

  group('[MicroAppEventController.emit()]', () {
    test(
        'Quando o controller emitir um evento sem channels, esse mesmo evento deve ser recebido na stream do controller',
        () {
      // arrange

      final handler1 = MicroAppEventHandler((event) {});
      final handler2 = MicroAppEventHandler((event) {});
      const event = MicroAppEvent(name: 'my_event');
      controller.registerHandler(handler1);
      controller.registerHandler(handler2);

      controller.stream.listen(expectAsync1<void, MicroAppEvent>((e) {
        expect(e, equals(event));
      }));

      // act
      controller.emit(event);
    });

    test(
        'Quando o controller emitir um evento sem channels, todos os handlers sem channels devem ser disparados',
        () {
      // arrange
      bool handler1Dispatched = false;
      bool handler2Dispatched = false;

      final handler1 = MicroAppEventHandler((event) {
        handler1Dispatched = true;
      });
      final handler2 = MicroAppEventHandler((event) {
        handler2Dispatched = true;
      });
      const event = MicroAppEvent(name: 'my_event');

      controller.registerHandler(handler1);
      controller.registerHandler(handler2);

      // assert
      expectLater(controller.stream.asBroadcastStream(), emits(event));
      Future.delayed(
          Duration.zero,
          () =>
              expect((handler1Dispatched && handler2Dispatched), equals(true)));

      // act
      controller.emit(event);
    });

    test(
        'Quando o controller emitir um evento com channels, apenas o handler que possui os mesmos channels(ou não possuir nenhum channel), devem ser disparado',
        () {
      // arrange
      bool handler1Dispatched = false;
      bool handler2Dispatched = false;
      bool handler3Dispatched = false;

      final handler1 = MicroAppEventHandler((event) {
        handler1Dispatched = true;
      });

      final handler2 = MicroAppEventHandler((event) {
        handler2Dispatched = true;
      }, channels: const ['channel1']);

      final handler3 = MicroAppEventHandler((event) {
        handler3Dispatched = true;
      }, channels: const ['channel3']);

      const event = MicroAppEvent(name: 'my_event', channels: ['channel1']);

      controller.registerHandler(handler1);
      controller.registerHandler(handler2);
      controller.registerHandler(handler3);

      // assert
      Future.delayed(
          Duration.zero,
          () => expect(
              (handler1Dispatched &&
                  handler2Dispatched &&
                  handler3Dispatched == false),
              equals(true)));

      // act
      controller.emit(event);
    });

    test(
        'Quando o controller emitir um evento com channels, apenas o handler que possui os mesmos channels, deve ser disparado',
        () {
      // arrange
      bool handler1Dispatched = false;
      bool handler2Dispatched = false;

      final handler1 = MicroAppEventHandler((event) {
        handler1Dispatched = true;
      }, channels: const ['channel1']);

      final handler2 = MicroAppEventHandler((event) {
        handler2Dispatched = true;
      }, channels: const ['channel2']);

      const event = MicroAppEvent(name: 'my_event', channels: ['channel1']);

      controller.registerHandler(handler1);
      controller.registerHandler(handler2);

      // assert
      Future.delayed(
          Duration.zero,
          () => expect((handler1Dispatched && handler2Dispatched == false),
              equals(true)));

      // act
      controller.emit(event);
    });
  });

  group('[MicroAppEventController.stream]', () {
    test(
        'Quando o controller emitir um evento, a stream do controller deve receber o evento corretamente em broadcast',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      const event = MicroAppEvent(name: 'my_event');

      controller.registerHandler(handler);

      // assert
      expectLater(controller.stream.asBroadcastStream(), emits(event));

      // act
      controller.emit(event);
    });
  });
}
