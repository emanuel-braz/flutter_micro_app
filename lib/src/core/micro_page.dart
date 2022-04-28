import '../entities/router/page_builder.dart';

/// [MicroAppPage] Create pages to be registered in [MicroApp]s
class MicroAppPage {
  final String route;
  final PageBuilder pageBuilder;
  MicroAppPage({
    required this.route,
    required this.pageBuilder,
  });
}
