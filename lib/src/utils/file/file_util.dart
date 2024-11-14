import 'dart:io';

class FileUtil {
  static Future<Map<String, List<String>>> getAllFiles(String folder) async {
    try {
      final libDirectory = Directory(folder);

      final Map<String, List<String>> fileDependencies = {};

      if (!libDirectory.existsSync()) {
        print('The lib directory does not exist.');
        throw Exception('The lib directory does not exist.');
      }

      await for (var file in libDirectory.list(recursive: true)) {
        if (file is File && file.path.endsWith('.dart')) {
          final imports = await _getImports(file);
          fileDependencies[_getFileName(file.path)] = imports;
        }
      }

      return fileDependencies;
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  static Future<List<String>> _getImports(File file) async {
    final lines = await file.readAsLines();
    final imports = <String>[];

    for (var line in lines) {
      final importMatch = RegExp(r"import\s+'([^']+)';").firstMatch(line);
      if (importMatch != null) {
        final importPath = importMatch.group(1)!;
        if (importPath.startsWith('package:') ||
            importPath.startsWith('dart:')) {
          continue;
        }
        imports.add(_getFileName(importPath));
      }

      final exportMatch = RegExp(r"export\s+'([^']+)';").firstMatch(line);
      if (exportMatch != null) {
        final exportPath = exportMatch.group(1)!;
        if (exportPath.startsWith('package:') ||
            exportPath.startsWith('dart:')) {
          continue;
        }
        imports.add(_getFileName(exportPath));
      }
    }

    return imports;
  }

  static String _getFileName(String path) {
    final segments = path.split('/');
    final fileName = segments.last;
    return fileName.replaceAll('.dart', '');
  }
}
