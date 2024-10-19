import 'package:flutter_micro_app/src/infra/app_config/index.dart';
import 'package:flutter_test/flutter_test.dart';

class TestRemoteConfig extends FmaRemoteConfig {
  TestRemoteConfig({
    super.getAll,
    super.getBool,
    super.getInt,
    super.getDouble,
    super.getString,
    super.getValue,
  });
}

void main() {
  group('AppConfigState', () {
    test('default constructor', () {
      final state = AppConfigState();
      expect(state.enabled, false);
      expect(state.config, {});
    });

    test('copyWith method', () {
      final state = AppConfigState($enabled: false);
      final newState = state.copyWith(enabled: true, config: {'key': 'value'});
      expect(newState.enabled, true);
      expect(newState.config, {'key': 'value'});
    });

    test('Defaults enum', () {
      expect(Defaults.boolType.value, false);
      expect(Defaults.intType.value, 0);
      expect(Defaults.doubleType.value, 0.0);
      expect(Defaults.stringType.value, '');
      expect(Defaults.mapType.value, <String, dynamic>{});
      expect(Defaults.listType.value, []);
      expect(Defaults.setType.value, {});
    });

    test('FmaRemoteConfig setState', () {
      final state = AppConfigState($enabled: false);
      FmaRemoteConfig.setState(state);
      final newState = FmaRemoteConfig.state;
      expect(newState.enabled, false);
      expect(newState.config, {});
    });
  });

  group('FmaRemoteConfig Tests', () {
    late TestRemoteConfig testRemoteConfig;

    setUp(() {
      testRemoteConfig = TestRemoteConfig(
        getBool: (key) => false,
        getInt: (key) => 1,
        getDouble: (key) => 0.1,
        getString: (key) => 'test1',
        getValue: (key) => 'dynamicvalue1',
      );

      testRemoteConfig.updateConfig(
        config: {
          'bool': true,
          'int': 2,
          'double': 0.2,
          'string': 'test2',
          'dynamic': 'dynamicvalue2',
        },
      );
    });

    test('updateConfig should update the config', () {
      testRemoteConfig.updateConfig(
        config: {
          'bool': false,
          'int': 0,
          'double': 0.0,
          'string': 'test',
          'dynamic': 'dynamicvalue',
        },
      );

      expect(FmaRemoteConfig.state.config, {
        'bool': false,
        'int': 0,
        'double': 0.0,
        'string': 'test',
        'dynamic': 'dynamicvalue',
      });
    });

    group('extension disabled', () {
      setUp(() {
        testRemoteConfig.updateConfig(enabled: false);
      });

      test('getBool should return the correct value', () {
        final result = testRemoteConfig.getBool('bool');
        expect(result, isFalse);
      });

      test('getInt should return the correct value', () {
        final result = testRemoteConfig.getInt('int');
        expect(result, 1);
      });

      test('getDouble should return the correct value', () {
        final result = testRemoteConfig.getDouble('double');
        expect(result, 0.1);
      });

      test('getString should return the correct value', () {
        final result = testRemoteConfig.getString('string');
        expect(result, 'test1');
      });

      test('getValue should return the correct value', () {
        final result = testRemoteConfig.getValue('dynamic');
        expect(result, 'dynamicvalue1');
      });
    });

    group('extension enabled', () {
      setUp(() {
        testRemoteConfig.updateConfig(enabled: true);
      });

      test('getBool should return the correct value', () {
        final result = testRemoteConfig.getBool('bool');
        expect(result, isTrue);
      });

      test('getInt should return the correct value', () {
        final result = testRemoteConfig.getInt('int');
        expect(result, 2);
      });

      test('getDouble should return the correct value', () {
        final result = testRemoteConfig.getDouble('double');
        expect(result, 0.2);
      });

      test('getString should return the correct value', () {
        final result = testRemoteConfig.getString('string');
        expect(result, 'test2');
      });

      test('getValue should return the correct value', () {
        final result = testRemoteConfig.getValue('dynamic');
        expect(result, 'dynamicvalue2');
      });
    });
  });
}
