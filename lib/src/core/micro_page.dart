import '../utils/typedefs.dart';

/// [MicroAppPage] Create pages to be registered in [MicroApp]s
class MicroAppPage {
  final String name;
  final PageBuilder builder;
  MicroAppPage({required this.name, required this.builder});
}
