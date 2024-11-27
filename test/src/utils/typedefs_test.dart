// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'When generic type from MicroAppEvent is defined, then it must infer generic type on MicroAppEventOnEvent',
      () {
    // Arrange
    final MicroAppEvent<String> event = MicroAppEvent(
      payload: 'test',
    );

    final MicroAppEventOnEvent onEvent = (event) {
      // Assert
      expect(event.runtimeType, MicroAppEvent<String>);
    };

    // Act
    onEvent(event);
  });

  test(
      'When generic type from MicroAppEventOnEvent is defined, then it must infer generic type on MicroAppEvent',
      () {
    // Arrange
    final event = MicroAppEvent(
      payload: 'test',
    );

    final MicroAppEventOnEvent<String> onEvent = (event) {
      // Assert
      expect(event.runtimeType, MicroAppEvent<String>);
    };

    // Act
    onEvent(event);
  });

  test(
      'When payload type is different from String type, then it should not infer type String',
      () {
    // Arrange
    final event = MicroAppEvent(
      payload: 123,
    );

    final MicroAppEventOnEvent onEvent = (event) {
      // Assert
      expect(event.runtimeType, isNot(equals(MicroAppEvent<String>)));
    };

    // Act
    onEvent(event);
  });
}
