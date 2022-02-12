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
        'channels': ['channel1', 'channel2']
      }));

      // assert
      expect(eventFromJson, isA<MicroAppEvent>());
      expect(eventFromJson?.channels.length, 2);
      expect(eventFromJson?.name, 'nome');
      expect(eventFromJson?.payload, 'abc');
      expect(eventFromJson?.type, 'String');
      expect(eventFromJson?.distinct, true);
    });

    test(
        'Deve converter um json válido, com lista de channels vazia, em um MicroAppEvent<String>',
        () {
      // arrange
      final eventFromJson = MicroAppEvent.fromJson(jsonEncode({
        'name': 'nome',
        'payload': 'abc',
        'channels': [],
        'distinct': false,
      }));

      // assert
      expect(eventFromJson, isA<MicroAppEvent>());
      expect(eventFromJson?.channels.length, 0);
      expect(eventFromJson?.name, 'nome');
      expect(eventFromJson?.payload, 'abc');
      expect(eventFromJson?.type, 'String');
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
      expect(eventFromJson?.type, 'String');
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
    final event = MicroAppEvent(
      name: 'nome',
      payload: 'abc',
      channels: const ['channel1', 'channel2'],
      distinct: true,
    );

    // act
    final eventAsString = event.toString();

    // assert
    expect(
        eventAsString,
        equals(
            '{"name":"nome","payload":"abc","channels":["channel1","channel2"],"distinct":true}'));
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
    final expectedResultMap = {
      'name': 'nome',
      'payload': 'abc',
      'distinct': false,
      'channels': ['channel1', 'channel2']
    };

    // assert
    expect(map, equals(expectedResultMap));
    expect(map, isA<Map<String, dynamic>>());
    expect(map.length, equals(4));
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
