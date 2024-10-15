import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../dependencies.dart';
import '../../../flutter_micro_app.dart';

class RemoteConfigRequest {
  final String key;
  final dynamic value;
  final Type? type;

  RemoteConfigRequest({
    required this.key,
    required this.value,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'type': type.toString(),
    };
  }

  factory RemoteConfigRequest.fromMap(Map<String, dynamic> map) {
    return RemoteConfigRequest(
      key: map['key'],
      value: map['value'],
      type: map['type'],
    );
  }
}

notifyMicroAppHasChanged(String microboardData) {
  try {
    if (kReleaseMode) return;
    postEvent(Constants.extensionToDevtoolsMicroBoardChanged,
        {'data': microboardData});
  } catch (e) {
    l.e('An error occurred while dispatching events to Devtools', error: e);
  }
}

notifyAppRemoteConfigDataHasChanged() {
  try {
    if (kReleaseMode) return;
    postEvent(
      Constants.notifyAppRemoteConfigDataHasChanged,
      {'success': true},
    );
  } catch (e) {
    l.e('An error occurred while notifying Devtools', error: e);
  }
}

notifyRequestRemoteConfig(RemoteConfigRequest remoteConfigRequest) {
  try {
    if (kReleaseMode) return;

    postEvent(
      Constants.notifyRequestRemoteConfig,
      {
        'success': true,
        'data': remoteConfigRequest.toMap(),
      },
    );
  } catch (e) {
    l.e('An error occurred while notifying Devtools', error: e);
  }
}
