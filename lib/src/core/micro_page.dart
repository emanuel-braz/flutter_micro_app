import 'package:flutter/widgets.dart';

import '../entities/router/page_builder.dart';

/// [MicroAppPage] Create pages to be registered in [MicroApp]s
class MicroAppPage<T extends Widget> {
  final String route;
  final PageBuilder<T> pageBuilder;
  final String description;
  final String name;
  final dynamic parameters;

  MicroAppPage({
    required this.route,
    required this.pageBuilder,
    String? description,
    String? name,
    this.parameters,
  })  : description = description ?? '',
        name = name ?? '';
}
