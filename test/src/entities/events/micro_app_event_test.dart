import 'dart:convert';

import 'package:flutter_micro_app/src/entities/events/micro_app_event.dart';
import 'package:flutter_test/flutter_test.dart';

/*
  Test descriptions are in Portuguese language
*/

void main() {
  group('[MicroAppEvent.fromJson]', () {
    test('Deve converter um json(String) válido em um MicroAppEvent<String>',
        () {
      // arrange
      final eventFromJson = MicroAppEvent.fromJson(jsonEncode({
        'name': 'nome',
        'payload': 'abc',
        'distinct': true,
        'channels': ['channel1', 'channel2'],
        'version': '1.0.0',
        'timestamp': '2020-01-01T00:00:00.000Z'
      }));

      // assert
      expect(eventFromJson, isA<MicroAppEvent>());
      expect(eventFromJson?.channels.length, 2);
      expect(eventFromJson?.name, 'nome');
      expect(eventFromJson?.payload, 'abc');
      expect(eventFromJson?.distinct, true);
      expect(eventFromJson?.type, equals(String));
      expect(eventFromJson?.version, equals('1.0.0'));
    });

    test(
        'Deve converter um json(String) válido em um MicroAppEvent<String> sem informar timestamp',
        () {
      // arrange
      final eventFromJson = MicroAppEvent.fromJson(jsonEncode({
        'name': 'nome',
        'payload': 'abc',
        'distinct': true,
        'channels': ['channel1', 'channel2'],
      }));

      // assert
      expect(eventFromJson, isA<MicroAppEvent>());
      expect(eventFromJson?.channels.length, 2);
      expect(eventFromJson?.name, 'nome');
      expect(eventFromJson?.payload, 'abc');
      expect(eventFromJson?.distinct, true);
      expect(eventFromJson?.type, equals(String));
      expect(eventFromJson?.version, equals(null));
    });

    test(
        'Deve converter um json válido, com lista de channels vazia, em um MicroAppEvent<int>',
        () {
      // arrange
      final eventFromJson = MicroAppEvent.fromJson(jsonEncode({
        'name': 'nome',
        'payload': 123,
        'channels': [],
        'distinct': false,
        'timestamp': '2020-01-01T00:00:00.000Z'
      }));

      // assert
      expect(eventFromJson, isA<MicroAppEvent>());
      expect(eventFromJson?.channels.length, 0);
      expect(eventFromJson?.name, 'nome');
      expect(eventFromJson?.payload, 123);
      expect(eventFromJson?.type, equals(int));
      expect(eventFromJson?.version, equals(null));
      expect(eventFromJson?.timestamp,
          equals(DateTime.parse('2020-01-01T00:00:00.000Z')));
    });

    test(
        'Deve converter um json válido, com lista de channels vazia, quando a lista não for informada, em um MicroAppEvent<String>',
        () {
      // arrange
      final eventFromJson = MicroAppEvent.fromJson(jsonEncode({
        'name': 'nome',
        'payload': 'abc',
        'distinct': true,
      }));

      // assert
      expect(eventFromJson, isA<MicroAppEvent>());
      expect(eventFromJson?.channels.length, 0);
      expect(eventFromJson?.name, 'nome');
      expect(eventFromJson?.payload, 'abc');
      expect(eventFromJson?.type, equals(String));
    });

    test('Não deve converter um json inválido, ', () {
      // arrange
      final eventFromJson = MicroAppEvent.fromJson(jsonEncode({
        'name': 123,
        'payload': null,
        'distinct': true,
      }));

      // assert
      expect(eventFromJson, isNull);
    });
  });

  test('Deve retornar uma String com valores do MicroAppEvent, corretamente',
      () {
    // arrange
    final timeStamp = DateTime.now();
    final event = MicroAppEvent(
        name: 'nome',
        payload: 'abc',
        channels: const ['channel1', 'channel2'],
        distinct: true,
        timestamp: timeStamp);

    // act
    final eventAsString = event.toString();

    // assert
    expect(
        eventAsString,
        equals(
            '{"name":"nome","payload":"abc","channels":["channel1","channel2"],"distinct":true,"methodCall":"null","version":null,"timestamp":"${timeStamp.toIso8601String()}"}'));
  });

  test('Deve converter o MicroAppEvent em um Map<String, dynamic> corretamente',
      () {
    // arrange
    final event = MicroAppEvent(
      name: 'nome',
      payload: 'abc',
      channels: const ['channel1', 'channel2'],
      distinct: false,
    );

    // act
    final map = event.toMap();

    // assert
    expect(map['name'], equals('nome'));
    expect(map['payload'], equals('abc'));
    expect(map['distinct'], equals(false));
    expect(map['channels'], equals(['channel1', 'channel2']));
    expect(map['version'], equals(null));

    expect(map, isA<Map<String, dynamic>>());
    expect(map.length, equals(6));
  });

  test('Deve fazer o cast do payload para String, corretamente', () {
    // arrange
    final event = MicroAppEvent(
        name: 'nome', payload: 'abc', channels: const ['channel1', 'channel2']);

    // act
    final payloadCast = event.cast();

    // assert
    expect(payloadCast, isA<String>());
    expect(payloadCast, equals('abc'));
  });

  test('Deve fazer o cast do payload para List<String>, corretamente', () {
    // arrange
    final event = MicroAppEvent(
        name: 'nome',
        payload: const ['abc'],
        channels: const ['channel1', 'channel2']);

    // act
    final payloadCast = event.cast();

    // assert
    expect(payloadCast, isA<List<String>>());
    expect(payloadCast?.length, equals(1));
  });

  test('Deve fazer o cast do payload para dynamic, corretamente', () {
    // arrange
    final event =
        MicroAppEvent(name: 'nome', channels: const ['channel1', 'channel2']);

    // act
    final payloadCast = event.cast();

    // assert
    expect(payloadCast, isNull);
  });
}
