// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../utils/extensions/devtools_extension_utils.dart';

@immutable
class AppConfigState {
  @protected
  final bool $enabled;
  bool get enabled => $enabled;

  @protected
  final Map<String, dynamic> $config;
  Map<String, dynamic> get config => $config;

  AppConfigState({
    this.$enabled = false,
    this.$config = const {},
  });

  AppConfigState copyWith({
    bool? enabled,
    Map<String, dynamic>? config,
  }) {
    return AppConfigState(
      $enabled: enabled ?? $enabled,
      $config: config ?? $config,
    );
  }
}

enum Defaults {
  boolType(false),
  intType(0),
  doubleType(0.0),
  stringType(''),
  mapType(<String, dynamic>{}),
  listType([]),
  setType({});

  final dynamic value;
  const Defaults(this.value);
}

abstract class FmaRemoteConfig {
  static ValueNotifier<AppConfigState> stateNotifier =
      ValueNotifier<AppConfigState>(AppConfigState());
  static AppConfigState get state => stateNotifier.value;

  static setState(AppConfigState state) {
    stateNotifier.value = state;
    notifyAppRemoteConfigDataHasChanged();
  }

  @Deprecated('Use getAll instead')
  @protected
  final FutureOr<Map<String, dynamic>> Function()? getAllFunction;

  @Deprecated('Use getBool instead')
  @protected
  final FutureOr<bool> Function(String key)? getBoolFunction;

  @Deprecated('Use getInt instead')
  @protected
  final FutureOr<int> Function(String key)? getIntFunction;

  @Deprecated('Use getDouble instead')
  @protected
  final FutureOr<double> Function(String key)? getDoubleFunction;

  @Deprecated('Use getString instead')
  @protected
  final FutureOr<String> Function(String key)? getStringFunction;

  @Deprecated('Use getValue instead')
  @protected
  final FutureOr<dynamic> Function(String key)? getValueFunction;

  FmaRemoteConfig({
    Map<String, dynamic> Function()? getAll,
    bool Function(String key)? getBool,
    int Function(String key)? getInt,
    double Function(String key)? getDouble,
    String Function(String key)? getString,
    dynamic Function(String key)? getValue,
  })  : getAllFunction = getAll,
        getBoolFunction = getBool,
        getIntFunction = getInt,
        getDoubleFunction = getDouble,
        getStringFunction = getString,
        getValueFunction = getValue;

  /// Update Remote Config with the given parameters.
  void updateConfig({Map<String, dynamic>? config, bool? enabled}) {
    // Avoid try updating Remote Config in release mode.
    if (kReleaseMode) return;

    setState(state.copyWith(
      config: config,
      enabled: enabled,
    ));
  }

  /// Verifies if the given key is present in the Remote Config.
  bool containsKey(String key) => state.$config.containsKey(key);

  /// Returns a Map of all Remote Config parameters.
  Map<String, dynamic> getAll({Map<String, dynamic>? fallback}) {
    late Map<String, dynamic> value;

    if (state.enabled && !kReleaseMode) {
      value = state.$config;

      notifyRequestRemoteConfig(
        RemoteConfigRequest(
          key: r'$all',
          value: value,
          type: value.runtimeType,
        ),
      );
    } else {
      value = getAllFunction?.call() ?? fallback ?? Defaults.mapType.value;
    }

    return value;
  }

  /// Gets the value for a given key as a bool.
  bool getBool(String key, {bool? fallback}) {
    late bool value;

    if (state.enabled && !kReleaseMode) {
      value = bool.tryParse((state.$config[key] ?? fallback).toString()) ??
          Defaults.boolType.value;

      notifyRequestRemoteConfig(
        RemoteConfigRequest(
          key: key,
          value: value,
          type: bool,
        ),
      );
    } else {
      value = getBoolFunction?.call(key) ?? fallback ?? Defaults.boolType.value;
    }

    return value;
  }

  /// Gets the value for a given key as an int.
  int getInt(String key, {int? fallback}) {
    late int value;

    if (state.enabled && !kReleaseMode) {
      value = int.tryParse((state.$config[key] ?? fallback).toString()) ??
          Defaults.intType.value;

      notifyRequestRemoteConfig(
        RemoteConfigRequest(
          key: key,
          value: value,
          type: int,
        ),
      );
    } else {
      value = getIntFunction?.call(key) ?? fallback ?? Defaults.intType.value;
    }

    return value;
  }

  /// Gets the value for a given key as a double.
  double getDouble(String key, {double? fallback}) {
    late double value;

    if (state.enabled && !kReleaseMode) {
      value = double.tryParse((state.$config[key] ?? fallback).toString()) ??
          Defaults.doubleType.value;

      notifyRequestRemoteConfig(
        RemoteConfigRequest(
          key: key,
          value: value,
          type: double,
        ),
      );
    } else {
      value =
          getDoubleFunction?.call(key) ?? fallback ?? Defaults.doubleType.value;
    }

    return value;
  }

  /// Gets the value for a given key as a String.
  String getString(String key, {String? fallback}) {
    late String value;

    if (state.enabled && !kReleaseMode) {
      value = ((state.$config[key] ?? fallback) ?? Defaults.stringType.value)
          .toString();

      notifyRequestRemoteConfig(
        RemoteConfigRequest(
          key: key,
          value: value,
          type: String,
        ),
      );
    } else {
      value =
          getStringFunction?.call(key) ?? fallback ?? Defaults.stringType.value;
    }

    return value;
  }

  /// Gets the value for a given key.
  dynamic getValue(String key, {dynamic fallback}) {
    late dynamic value;

    if (state.enabled && !kReleaseMode) {
      value = state.$config[key] ?? fallback;

      notifyRequestRemoteConfig(
        RemoteConfigRequest(
          key: key,
          value: value,
          type: value.runtimeType,
        ),
      );
    } else {
      value = getValueFunction?.call(key) ?? fallback;
    }

    return value;
  }
}
