import 'dart:convert';
import 'dart:developer';

import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../models/micro_board_data.dart';
import '../notifiers/custom_value_notifier.dart';

class FmaState {
  Map<String, dynamic>? _microBoardMap;
  Map<String, dynamic>? get microBoardMap => _microBoardMap;
  Map<String, dynamic> remoteConfig = {};
  bool enabled = false;
  MicroBoardData get microBoardData => MicroBoardData.fromMap(_microBoardMap);
}

class FmaController extends ValueNotifier<FmaState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final requestRemoteConfigKey = CustomValueNotifier<String?>(null);
  final requestedKeys = <String, ItemFetched>{};

  void alertRequestRemoteConfigKeyFetched({
    required String key,
    required String type,
    dynamic value,
  }) {
    final now = DateTime.now();
    final timeToDisplay =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    if (FmaController().requestedKeys[key] != null) {
      FmaController().requestedKeys[key]!.count++;
    } else {
      FmaController().requestedKeys[key] =
          ItemFetched(time: timeToDisplay, count: 1, key: key);
    }

    requestRemoteConfigKey.notifyValue(key);
  }

  void removeItem(ItemFetched item) {
    requestedKeys.remove(item.key);
    notifyListeners();
  }

  Future<void> updateView() async {
    try {
      final response = await serviceManager.callServiceExtensionOnMainIsolate(
          Constants.devtoolsToExtensionUpdate,
          args: {});

      value._microBoardMap = response.json;
      notifyListeners();
    } catch (e) {
      l.e(e.toString());
    }
  }

  Future<void> syncRemoteConfigData(
      {bool? enabled, Map<String, dynamic>? parameters}) async {
    try {
      if (parameters == null && enabled == null) {
        final response = await serviceManager.callServiceExtensionOnMainIsolate(
          Constants.extensionToDevtoolsSyncRemoteConfigMap,
        );

        final json = response.json ?? {};

        if (json['data'] != null) {
          value.remoteConfig = json['data'];
        }

        if (json['enabled'] != null) {
          value.enabled = json['enabled'];
        }

        notifyListeners();
      } else {
        final args = <String, dynamic>{
          if (parameters != null) 'data': jsonEncode(parameters['data']),
          if (enabled != null) 'enabled': enabled,
        };

        final response = await serviceManager.callServiceExtensionOnMainIsolate(
            Constants.extensionToDevtoolsSyncRemoteConfigMap,
            args: args);

        final json = response.json ?? {};

        final isSuccess = json['success'] ?? false;

        if (isSuccess) {
          serviceManager.performHotReload();
          notifyListeners();
        } else {
          showMessage(json['message'] ?? 'Failed to sync remote config');
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  FmaController._privateConstructor() : super(FmaState());
  static final FmaController _instance = FmaController._privateConstructor();
  factory FmaController() {
    return _instance;
  }

  void showMessage(String message) {
    final scaffoldMessenger =
        ScaffoldMessenger.of(FmaController().scaffoldKey.currentContext!);

    scaffoldMessenger.clearSnackBars();

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }

  void showNotification(String message) {
    extensionManager.postMessageToDevTools(
      ShowNotificationExtensionEvent(message: message),
    );
  }
}

class ItemFetched {
  String key;
  String time;
  int count;

  ItemFetched({
    required this.time,
    required this.count,
    required this.key,
  });
}
