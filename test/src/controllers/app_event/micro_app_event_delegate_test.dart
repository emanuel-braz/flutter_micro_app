import 'package:flutter_micro_app/src/controllers/app_event/micro_app_event_controller.dart';
import 'package:flutter_micro_app/src/controllers/app_event/micro_app_event_delegate.dart';
import 'package:flutter_micro_app/src/entities/events/micro_app_event.dart';
import 'package:flutter_micro_app/src/entities/events/micro_app_event_handler.dart';
import 'package:flutter_test/flutter_test.dart';

/*
  Test descriptions are in Portuguese language
*/

void main() {
  late MicroAppEventDelegate microAppEventHelper;
  late MicroAppEventController controller;

  setUp(() {
    controller = MicroAppEventController.$testOnlyPurpose();
    microAppEventHelper = MicroAppEventDelegate();
  });

  test(
      'Quando um evento sem channels for emitido, deve disparar o handler, se handler nao tiver channels definidos',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {});
    final event = MicroAppEvent(name: 'my_event');
    controller.registerHandler(handler);

    // act
    final result =
        microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels);

    // assert
    expect(result, equals(true));
  });

  test(
      'Quando um evento com channels for emitido, deve disparar o handler, se handler nao tiver channels definidos',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {});
    final event = MicroAppEvent(name: 'my_event', channels: const ['channel1']);
    controller.registerHandler(handler);

    // act
    final result =
        microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels);

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
    final event = MicroAppEvent(
        name: 'my_event',
        channels: const ['channel1', commonChannel, 'channel3']);
    controller.registerHandler(handler);

    // act
    final result =
        microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels);

    // assert
    expect(result, equals(true));
  });

  test(
      'Quando um evento com channels for emitido, Não deve disparar o handler, se handler tiver algum channel, mas que Não seja nenhum dos channels existentes no evento',
      () {
    // arrange
    final handler =
        MicroAppEventHandler((event) {}, channels: const ['channel1']);
    final event = MicroAppEvent(
        name: 'my_event', channels: const ['channel2', 'channel3']);

    // act
    controller.registerHandler(handler);

    // act
    final result =
        microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels);

    // assert
    expect(result, equals(false));
  });

  test(
      'Quando o controller emitir um evento com mútiplos channels, deve disparar o handler, se o handler tiver um channel que exista também no evento',
      () {
    // arrange
    final handler =
        MicroAppEventHandler((event) {}, channels: const ['channel1']);
    final event = MicroAppEvent(
        name: 'my_event', channels: const ['channel1', 'channel2', 'channel3']);
    controller.registerHandler(handler);

    // act
    final result =
        microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels);

    // assert
    expect(result, equals(true));
  });

  test(
      'Quando o controller emitir um evento com um único channel, deve disparar o handler, se o handler tiver múltiplos channels, e pelo menos um, exista também no evento',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {},
        channels: const ['channel1', 'channel2', 'channel3']);
    final event = MicroAppEvent(name: 'my_event', channels: const ['channel3']);
    controller.registerHandler(handler);

    // act
    final result =
        microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels);

    // assert
    expect(result, equals(true));
  });

  //---

  test(
      'O handler deve ser encontrado nos registros, caso o channel informado coincidir',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {},
        channels: const ['channel1', 'channel2', 'channel3']);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, ['channel2']);

    expect(handlerSholdBeFoundInHandlersMap, equals(true));
  });

  test(
      'O handler deve ser encontrado nos registros, em caso de um ou mais channels coincidirem',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {},
        channels: const ['channel1', 'channel2']);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, ['channel2', 'channel1']);

    expect(handlerSholdBeFoundInHandlersMap, equals(true));
  });

  test(
      'O handler deve ser encontrado nos registros, em caso de um channel coincidir',
      () {
    // arrange
    final handler =
        MicroAppEventHandler((event) {}, channels: const ['channel1']);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, ['channel2', 'channel1']);

    expect(handlerSholdBeFoundInHandlersMap, equals(true));
  });

  test(
      'O handler Não deve ser encontrado nos registros, caso a lista de channels informada esteja vazia e o handler tenha ao menos um channel',
      () {
    // arrange
    final handler =
        MicroAppEventHandler((event) {}, channels: const ['channel1']);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(handler.channels, []);

    expect(handlerSholdBeFoundInHandlersMap, equals(false));
  });

  test(
      'O handler será encontrado nos registros, caso a lista de channels dele esteja vazia, mesmo que seja informado um ou mais channels na busca',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {}, channels: const []);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, ['channel1']);

    expect(handlerSholdBeFoundInHandlersMap, equals(true));
  });

  test(
      'O handler será encontrado nos registros, caso a lista de channels dele esteja vazia, e seja informado uma lista vazia de channels na busca',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {}, channels: const []);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(handler.channels, []);

    expect(handlerSholdBeFoundInHandlersMap, equals(true));
  });

  test(
      'O handler Não será encontrado nos registros, caso a lista de channels informada na coincida com a lista de channels do handler',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {},
        channels: const ['channel1', 'channel2', 'channel3', 'channel4']);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, ['channelA', 'channelB', 'channelC']);

    expect(handlerSholdBeFoundInHandlersMap, equals(false));
  });

  test(
      'O handler Não será encontrado nos registros, caso a lista de channels informada tenha um unico channel que não na coincida com qualquer channel na lista de channels do handler',
      () {
    // arrange
    final handler = MicroAppEventHandler((event) {},
        channels: const ['channel1', 'channel2', 'channel3', 'channel4']);

    final handlerSholdBeFoundInHandlersMap = microAppEventHelper
        .containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, ['channelA']);

    expect(handlerSholdBeFoundInHandlersMap, equals(false));
  });

  // ---

  group('[MicroAppEventDelegate.handlerHasSameEventType]', () {
    test('Quando informar handler e evento do tipo String, deve retornar true',
        () {
      // arrange
      final handler =
          MicroAppEventHandler<String>((event) {}, channels: const ['1', '2']);
      final event =
          MicroAppEvent<String>(name: 'my_event', channels: const ['1', '2']);

      // act
      bool isTypeEquals =
          microAppEventHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(true));
    });

    test(
        'Quando informar handler de tipo int e evento do tipo String, deve retornar false',
        () {
      // arrange
      final handler = MicroAppEventHandler<int>((event) {});
      final event = MicroAppEvent<String>(name: 'my_event');

      // act
      bool isTypeEquals =
          microAppEventHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(false));
    });

    test(
        'Quando informar handler de tipo String e evento do tipo int, deve retornar false',
        () {
      // arrange
      final handler = MicroAppEventHandler<String>((event) {});
      final event = MicroAppEvent<int>(name: 'my_event');

      // act
      bool isTypeEquals =
          microAppEventHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(false));
    });

    test(
        'Quando informar handler de tipo dynamic e evento do tipo List<String>, deve retornar false',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      final event = MicroAppEvent<List<String>>(name: 'my_event');

      // act
      bool isTypeEquals =
          microAppEventHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(true));
    });

    test(
        'Quando informar handler sem tipo e evento com tipo String, deve retornar true',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      final event = MicroAppEvent<String>(name: 'my_event');

      // act
      bool isTypeEquals =
          microAppEventHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(true));
    });

    test(
        'Quando informar handler com tipo String e evento sem tipo, deve retornar false',
        () {
      // arrange
      final handler = MicroAppEventHandler<String>((event) {});
      final event = MicroAppEvent(name: 'my_event');

      // act
      bool isTypeEquals =
          microAppEventHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(false));
    });
  });

  group('[MicroAppEventDelegate.isChannelsIntersection]', () {
    test(
        'Deve retornar true quando o handler tiver um channel em comum com o evento dentro de uma lista de channels',
        () {
      // arrange
      final c1 = [
        '123',
        'comun',
        'algo',
        'teste1',
      ];
      final c2 = [
        '456',
        'channel1',
        'comun',
        ' -',
      ];
      final handler = MicroAppEventHandler<String>((event) {}, channels: c1);
      final event = MicroAppEvent<String>(name: 'my_event', channels: c2);

      // act
      bool hasSomeChannels =
          microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
              handler.channels, event.channels);

      // assert
      expect(hasSomeChannels, equals(true));
    });

    test(
        'Deve retornar true quando o handler não tiver channels registrados e evento também não',
        () {
      // arrange
      final handler = MicroAppEventHandler<String>((event) {});
      final event = MicroAppEvent<String>(name: 'my_event');

      // act
      bool hasSomeChannels =
          microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
              handler.channels, event.channels);

      // assert
      expect(hasSomeChannels, equals(true));
    });

    test(
        'Deve retornar true quando o handler não tiver channels registrados, mas o evento tenha',
        () {
      // arrange
      final handler = MicroAppEventHandler<String>((event) {});
      final event = MicroAppEvent<String>(
          name: 'my_event', channels: const ['some_channel']);

      // act
      bool hasSomeChannels =
          microAppEventHelper.containsSomeChannelsOrHandlerHasNoChannels(
              handler.channels, event.channels);

      // assert
      expect(hasSomeChannels, equals(true));
    });
  });

  group('[MicroAppEventDelegate.unregisterHandler]', () {
    test(
        'Deve registrar 2 handlers, e remover o handler2'
        'Quando remover apenas o handler2 com o comando unregisterHandler',
        () async {
      final handler1 = MicroAppEventHandler<String>((event) {});
      final handler2 = MicroAppEventHandler<String>((event) {});

      controller.registerHandler(handler1);
      controller.registerHandler(handler2);

      final handler = await controller.unregisterHandler(handler: handler2);

      expect(controller.handlers.length, 1);
      expect(handler, equals(handler2));
      expect(identical(controller.handlers.keys.first, handler1), equals(true));
    });

    test(
        'Deve registrar 2 handlers, e remover o handler1'
        'Quando tentar remover apenas o handler1 com o comando unregisterHandler',
        () async {
      final handler1 = MicroAppEventHandler<String>((event) {});
      final handler2 = MicroAppEventHandler<String>((event) {});

      controller.registerHandler(handler1);
      controller.registerHandler(handler2);

      final handler = await controller.unregisterHandler(handler: handler1);

      expect(controller.handlers.length, 1);
      expect(handler, equals(handler1));
      expect(identical(controller.handlers.keys.first, handler2), equals(true));
    });

    test(
        'Não deve interceptar qualquer evento pelo handler'
        'Quando este handler for desregistrado', () async {
      int count = 0;
      final handler = MicroAppEventHandler<String>((event) {
        count++;
      });

      expect(controller.handlers.length, equals(0));

      controller.registerHandler(handler);

      expect(controller.handlers.length, equals(1));

      await controller.unregisterHandler(handler: handler);

      expect(controller.handlers.length, equals(0));

      controller.emit(MicroAppEvent<String>(name: 'name', payload: 'data'));

      await Future.delayed(Duration.zero);
      expect(count, equals(0));
    });
  });
}
