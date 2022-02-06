import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_test/flutter_test.dart';

class SpecializedClass {
  final int id;
  SpecializedClass(this.id);
}

/*
  Test descriptions are in Portuguese language
*/

void main() {
  late MicroAppEventController controller;
  late HandlerRegisterHelper registerHelper;

  // fixtures
  final eventTypeString =
      MicroAppEvent<String>(name: 'eventTypeString', payload: 'payload_ok');
  final eventTypeListListString = MicroAppEvent<List<List<String>>>(
      name: 'eventTypeListListString',
      payload: const [
        ['a', 'b'],
        ['c', 'd']
      ]);
  final eventTypeInt = MicroAppEvent<int>(name: 'eventTypeInt', payload: 1);
  final eventTypeDynamic =
      MicroAppEvent(name: 'dynamic', payload: const {'name': 'turing'});
  final eventTypeSpecialized = MicroAppEvent<SpecializedClass>(
      name: 'eventTypeSpecialized', payload: SpecializedClass(1));

  setUpAll(() {
    MicroAppPreferences.update(MicroAppConfig(
        nativeEventsEnabled: false,
        pathSeparator: MicroAppPathSeparator.slash));
  });

  setUp(() {
    controller = MicroAppEventController.$testOnlyPurpose();
    registerHelper = HandlerRegisterHelper();
  });

  test(
      'Quando um evento de List<List<String>> for emitido, deve disparar o handler, apenas quando handler possuir a mesma tipagem',
      () async {
    // arrange
    List<List<String>>? payloadListListString;
    final subscription = controller
        .registerHandler(MicroAppEventHandler<List<List<String>>>((event) {}));

    controller.emit(eventTypeDynamic);
    controller.emit(eventTypeString);
    controller.emit(eventTypeInt);
    controller.emit(eventTypeSpecialized);
    controller.emit(eventTypeListListString);
    controller.emit(eventTypeInt);

    // assert
    subscription!.onData((event) {
      payloadListListString = event.cast();
      expect(event.payload.runtimeType.toString(), 'List<List<String>>');
      expect(
          payloadListListString.runtimeType.toString(), 'List<List<String>>');
      expect(eventTypeListListString.cast()?.length, equals(2));
    });

    await Future.delayed(Duration.zero);
    // Handler was called
    expect(payloadListListString, equals(eventTypeListListString.cast()));
  });

  group('[HandlerRegisterHelper]', () {
    test(
        'Quando um evento sem channels for emitido, deve disparar o handler, se handler nao tiver channels definidos',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      final event = MicroAppEvent(name: 'my_event');
      controller.registerHandler(handler);

      // act
      final result = registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
          handler.channels, event.channels);

      // assert
      expect(result, equals(true));
    });

    test(
        'Quando um evento com channels for emitido, deve disparar o handler, se handler nao tiver channels definidos',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {});
      final event =
          MicroAppEvent(name: 'my_event', channels: const ['channel1']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
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
      final result = registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
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
      final result = registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
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
          name: 'my_event',
          channels: const ['channel1', 'channel2', 'channel3']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
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
      final event =
          MicroAppEvent(name: 'my_event', channels: const ['channel3']);
      controller.registerHandler(handler);

      // act
      final result = registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
          handler.channels, event.channels);

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

      final handlerSholdBeFoundInHandlersMap = registerHelper
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

      final handlerSholdBeFoundInHandlersMap = registerHelper
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

      final handlerSholdBeFoundInHandlersMap = registerHelper
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

      final handlerSholdBeFoundInHandlersMap = registerHelper
          .containsSomeChannelsOrHandlerHasNoChannels(handler.channels, []);

      expect(handlerSholdBeFoundInHandlersMap, equals(false));
    });

    test(
        'O handler será encontrado nos registros, caso a lista de channels dele esteja vazia, mesmo que seja informado um ou mais channels na busca',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {}, channels: const []);

      final handlerSholdBeFoundInHandlersMap = registerHelper
          .containsSomeChannelsOrHandlerHasNoChannels(
              handler.channels, ['channel1']);

      expect(handlerSholdBeFoundInHandlersMap, equals(true));
    });

    test(
        'O handler será encontrado nos registros, caso a lista de channels dele esteja vazia, e seja informado uma lista vazia de channels na busca',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {}, channels: const []);

      final handlerSholdBeFoundInHandlersMap = registerHelper
          .containsSomeChannelsOrHandlerHasNoChannels(handler.channels, []);

      expect(handlerSholdBeFoundInHandlersMap, equals(true));
    });

    test(
        'O handler Não será encontrado nos registros, caso a lista de channels informada na coincida com a lista de channels do handler',
        () {
      // arrange
      final handler = MicroAppEventHandler((event) {},
          channels: const ['channel1', 'channel2', 'channel3', 'channel4']);

      final handlerSholdBeFoundInHandlersMap = registerHelper
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

      final handlerSholdBeFoundInHandlersMap = registerHelper
          .containsSomeChannelsOrHandlerHasNoChannels(
              handler.channels, ['channelA']);

      expect(handlerSholdBeFoundInHandlersMap, equals(false));
    });
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
      final event =
          MicroAppEvent(name: 'my_event', channels: const ['channel1']);

      // act
      controller.registerHandler(handler1);
      controller.registerHandler(handler2);
      await controller.unregisterAllHandlers();
      controller.emit(event);
      await Future.delayed(Duration.zero);

      expect(handler1Dispatched, equals(false));
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
      expect(controller.hasHandler(id: handler2Id, channels: const ['abcdef']),
          equals(true));
    });

    test(
        'Quando o handler tiver id = "ABC" e channel "abcd", deve retornar true, mesmo que não coincida o channel, pois o id tem prioridade',
        () {
      //arrange
      const id = 'ABC';
      final handler =
          MicroAppEventHandler((event) {}, channels: const ['abcd'], id: id);

      // act
      controller.registerHandler(handler);

      // assert
      expect(controller.hasHandler(id: id), equals(true));
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

    test(
        'Quando informado lista de channels vazio no metodo hasHandler e o registro possuir um ou mais handler com channels definidos, deve retornar false',
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
      final hasHandler = controller.hasHandler(channels: []);

      expect(hasHandler, equals(false));
    });

    test(
        'Deve retornar true, quando informado lista de channels vazio no metodo hasHandler e o registro possuir um handler com lista de channels vazio e id igual a "ABC"'
        '', () {
      final handler =
          MicroAppEventHandler((event) {}, channels: const [], id: 'ABC');

      // act
      controller.registerHandler(handler);
      final hasHandler = controller.hasHandler(channels: []);

      expect(hasHandler, equals(true));
    });

    test(
        'Deve retornar true, quando informado lista de channels vazio no metodo hasHandler e o registro possuir um handler com lista de channels vazio'
        '', () {
      final handler = MicroAppEventHandler((event) {}, channels: const []);

      // act
      controller.registerHandler(handler);
      final hasHandler = controller.hasHandler(channels: []);

      expect(hasHandler, equals(true));
    });

    test(
        'Deve: encontrar o handler'
        'Quando: informado o "channel1" no metodo "hasHandler"'
        'Desde que: o registro possua um handler com id definido igual a "ABC" e com channel igual a "channel1"',
        () {
      const handlerId = 'ABC';
      const channels = ['channel1'];

      final handler =
          MicroAppEventHandler((event) {}, channels: channels, id: handlerId);

      // act
      controller.registerHandler(handler);
      final hasHandler = controller.hasHandler(channels: channels);

      expect(hasHandler, equals(true));
    });

    test(
        'Deve: encontrar o handler'
        'Quando: informado o "channel1" e o id "ABC" no metodo "hasHandler"'
        'Desde que: o registro possua um handler com id definido igual a "ABC" e com channel igual a "channel1"',
        () {
      const handlerId = 'ABC';
      const channels = ['channel1'];

      final handler =
          MicroAppEventHandler((event) {}, channels: channels, id: handlerId);

      // act
      controller.registerHandler(handler);
      final hasHandler =
          controller.hasHandler(channels: channels, id: handlerId);

      expect(hasHandler, equals(true));
    });

    test(
        'Deve: encontrar o handler'
        'Quando: informado o id "ABC" no metodo "hasHandler"'
        'Desde que: o registro possua um handler com id definido igual a "ABC" e com channel igual a "channel1"',
        () {
      const handlerId = 'ABC';
      const channels = ['channel1'];

      final handler =
          MicroAppEventHandler((event) {}, channels: channels, id: handlerId);

      // act
      controller.registerHandler(handler);
      final hasHandler = controller.hasHandler(id: handlerId);

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
      final event = MicroAppEvent(name: 'my_event');
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
      final event = MicroAppEvent(name: 'my_event');

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

      final event =
          MicroAppEvent(name: 'my_event', channels: const ['channel1']);

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

      final event =
          MicroAppEvent(name: 'my_event', channels: const ['channel1']);

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
      final event = MicroAppEvent(name: 'my_event');

      controller.registerHandler(handler);

      // assert
      expectLater(controller.stream.asBroadcastStream(), emits(event));

      // act
      controller.emit(event);
    });
  });

  group('[HandlerRegisterHelper.handlerHasSameEventType]', () {
    test('Quando informar handler e evento do tipo String, deve retornar true',
        () {
      // arrange
      final handler =
          MicroAppEventHandler<String>((event) {}, channels: const ['1', '2']);
      final event =
          MicroAppEvent<String>(name: 'my_event', channels: const ['1', '2']);

      // act
      bool isTypeEquals =
          registerHelper.handlerHasSameEventTypeOrDynamic(handler, event);

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
          registerHelper.handlerHasSameEventTypeOrDynamic(handler, event);

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
          registerHelper.handlerHasSameEventTypeOrDynamic(handler, event);

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
          registerHelper.handlerHasSameEventTypeOrDynamic(handler, event);

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
          registerHelper.handlerHasSameEventTypeOrDynamic(handler, event);

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
          registerHelper.handlerHasSameEventTypeOrDynamic(handler, event);

      // assert
      expect(isTypeEquals, equals(false));
    });
  });

  group('[HandlerRegisterHelper.isChannelsIntersection]', () {
    test(
        'asdasdasdsad asd Deve retornar true quando o handler asdasdsanão tiver channels registrados e evento também não',
        () {
      // arrange
      final c1 = [
        'asd',
        'qwsqweqw',
        'idbfsd',
        'ajnd asd',
        '12sasdads',
        'dnwe3iuwe',
        'endiue',
        ' 23wdfsdcsdsdsdfsdf'
      ];
      final c2 = [
        '7h87ah8dh',
        'qwsqweqw',
        'adjkabskdjbkas',
        'asdsasd asd',
        'asdasdqwqweqweqw',
        'vmmcnv',
        '99bjjfgbj9fg',
        ' -'
      ];
      final handler = MicroAppEventHandler<String>((event) {}, channels: c1);
      final event = MicroAppEvent<String>(name: 'my_event', channels: c2);

      // act
      bool hasSomeChannels =
          registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
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
          registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
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
          registerHelper.containsSomeChannelsOrHandlerHasNoChannels(
              handler.channels, event.channels);

      // assert
      expect(hasSomeChannels, equals(true));
    });
  });

  group('[MicroAppEventHandler]', () {
    test(
        'Quando o handler não possuir uma tipagem especifica, ele deve ser disparado por qualquer evento',
        () {
      // arrange
      int count = 0;
      var microAppEventHandler = MicroAppEventHandler((event) {
        expect(event.payload, isNotNull);
        count++;
      });

      controller.registerHandler(microAppEventHandler);

      expectLater(
          controller.stream.asBroadcastStream(),
          emitsInOrder([
            eventTypeString,
            eventTypeInt,
            eventTypeDynamic,
            eventTypeSpecialized
          ]));

      controller.emit(eventTypeString);
      controller.emit(eventTypeInt);
      controller.emit(eventTypeDynamic);
      controller.emit(eventTypeSpecialized);

      Future.delayed(Duration.zero, () {
        expect(count, equals(4));
      });
    });

    test(
        'Quando o handler possuir tipagem de String[MicroAppEventHandler<String>], ele deve ser disparado apenas com eventos com payload de String',
        () async {
      // arrange
      String? payloadString = 'error';
      final subscription =
          controller.registerHandler(MicroAppEventHandler<String>((event) {}));

      controller.emit(eventTypeDynamic);
      controller.emit(eventTypeString);
      controller.emit(eventTypeInt);
      controller.emit(eventTypeSpecialized);

      // assert
      subscription!.onData((event) {
        payloadString = event.payload;
        expect(event.payload.runtimeType.toString(), 'String');
        expect(event.payload, equals(eventTypeString.cast()));
      });

      await Future.delayed(Duration.zero);
      // Handler was called
      expect(payloadString, equals(eventTypeString.cast()));
    });

    test(
        'Quando o handler possuir tipagem de String [MicroAppEventHandler<String>], ele deve NÃO deve ser disparado com payload diferente de String',
        () async {
      // arrange
      int count = 0;
      final subscription =
          controller.registerHandler(MicroAppEventHandler<String>((event) {}));

      // act
      controller.emit(eventTypeDynamic);
      controller.emit(eventTypeInt);
      controller.emit(eventTypeSpecialized);

      // assert
      subscription!.onData((event) {
        count++;
      });

      await Future.delayed(Duration.zero);

      // Handler was called
      expect(count, equals(0));
    });
  });
}
