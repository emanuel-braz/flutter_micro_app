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

  static const String notTyped = 'Not Typed';
}
