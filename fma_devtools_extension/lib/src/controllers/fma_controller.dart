import 'dart:developer';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import '../models/micro_board_data.dart';

class FmaState {
  Map<String, dynamic>? _microBoardMap;
  Map<String, dynamic>? get microBoardMap => _microBoardMap;
  MicroBoardData get microBoardData => MicroBoardData.fromMap(_microBoardMap);
}

class FmaController extends ValueNotifier<FmaState> {
  Future<void> updateView() async {
    try {
      final response = await serviceManager.callServiceExtensionOnMainIsolate(
          'ext.dev.emanuelbraz.fma.devtoolsToExtensionUpdate',
          args: {});

      value._microBoardMap = response.json;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  FmaController._privateConstructor() : super(FmaState());
  static final FmaController _instance = FmaController._privateConstructor();
  factory FmaController() {
    return _instance;
  }
}
