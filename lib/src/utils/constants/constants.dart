class Constants {
  // Platform Channels
  static String channelAppEvents = 'flutter/micro_app/app/events';
  static String channelRouterLoggerEvents =
      'flutter/micro_app/router/logger_events';
  static String channelRouterCommandEvents =
      'flutter/micro_app/router/command_events';

  // Methods
  static String methodMicroAppEvent = 'app_event';
  static String methodNavigationLog = 'navigation_log';
  static String methodNavigationCommand = 'navigation_command';
}
