import 'dart:developer';

import '../../../dependencies.dart';
import '../../../flutter_micro_app.dart';

notifyDevtoolsMicroBoardChanged(String microboardData) {
  try {
    postEvent(Constants.extensionToDevtoolsMicroBoardChanged,
        {'data': microboardData});
  } catch (e) {
    logger.e('An error occurred while dispatching events to Devtools',
        error: e);
  }
}
