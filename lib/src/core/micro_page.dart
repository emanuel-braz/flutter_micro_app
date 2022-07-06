import 'package:flutter/widgets.dart';

import '../entities/router/page_builder.dart';

/// [MicroAppPage] Create pages to be registered in [MicroApp]s
class MicroAppPage<T extends Widget> {
  final String route;
  final PageBuilder<T> pageBuilder;
  MicroAppPage({
    required this.route,
    required this.pageBuilder,
  });
}
