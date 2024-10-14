class Constants {
  // Platform Channels
  static const String channelAppEvents = 'flutter/micro_app/app/events';
  static const String channelRouterLoggerEvents =
      'flutter/micro_app/router/logger_events';
  static const String channelRouterCommandEvents =
      'flutter/micro_app/router/command_events';

  // Methods
  static const String methodMicroAppEvent = 'app_event';
  static const String methodNavigationLog = 'navigation_log';
  static const String methodNavigationCommand = 'navigation_command';

  static const flutterMicroAppEvent = 'FlutterMicroAppEvent';

  static const String notTyped = 'Not Typed';

  static const String devtoolsExtensionChannel = 'ext.dev.emanuelbraz.fma';
  static const String devtoolsToExtensionUpdate =
      '$devtoolsExtensionChannel.devtoolsToExtensionUpdate';
  static const String devtoolsToExtensionMicroAppEvent =
      '$devtoolsExtensionChannel.devtoolsToExtensionMicroAppEvent';
  static const String extensionToDevtoolsMicroBoardChanged =
      '$devtoolsExtensionChannel.extensionToDevtoolsMicroBoardChanged';

  // Remote Config
  static const String notifyAppRemoteConfigDataHasChanged =
      '$devtoolsExtensionChannel.notifyAppRemoteConfigDataHasChanged';
  static const String extensionToDevtoolsSyncRemoteConfigMap =
      '$devtoolsExtensionChannel.extensionToDevtoolsSyncRemoteConfigMap';
  static const String requestRemoteConfigData =
      '$devtoolsExtensionChannel.requestRemoteConfigData';
}
