import 'dart:io';

class FileUtil {
  static Future<Map<String, Map<String, dynamic>>> getAllFiles(
      String folder) async {
    try {
      final libDirectory = Directory(folder);
      final Map<String, Map<String, dynamic>> fileDependencies = {};

      if (!libDirectory.existsSync()) {
        print('The lib directory does not exist.');
        throw Exception('The lib directory does not exist.');
      }

      await for (var file in libDirectory.list(recursive: true)) {
        if (file is File &&
            file.path.endsWith('.dart') &&
            !file.path.endsWith('.g.dart') &&
            !file.path.endsWith('.freezed.dart')) {
          final imports = await _getImports(file, folder);

          if (fileDependencies[file.path] != null) {
            fileDependencies[file.path]!['imports'].addAll(imports);
          } else {
            fileDependencies[file.path] = {
              'imports': imports,
              'fileName': _getFileName(file.path),
              'filePath': file.path,
            };
          }
        }
      }

      return fileDependencies;
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  static Future<List<Map<String, dynamic>>> _getImports(
      File file, String folder) async {
    final lines = await file.readAsLines();
    final List<Map<String, dynamic>> imports = [];

    for (var line in lines) {
      final importMatch = RegExp(r"import\s+'([^']+)';").firstMatch(line);
      if (importMatch != null) {
        final importPath = importMatch.group(1)!;
        if (importPath.startsWith('package:') ||
            importPath.startsWith('dart:') ||
            importPath.endsWith('.g.dart') ||
            importPath.endsWith('.freezed.dart')) {
          continue;
        }

        final resolvedPath = getAbsoluteImportPath(file.path, importPath);

        imports.add({
          'fileName': _getFileName(importPath),
          'filePath': resolvedPath,
          'relativePath': importPath,
        });
      }

      final exportMatch = RegExp(r"export\s+'([^']+)';").firstMatch(line);
      if (exportMatch != null) {
        final exportPath = exportMatch.group(1)!;
        if (exportPath.startsWith('package:') ||
            exportPath.startsWith('dart:') ||
            exportPath.endsWith('.g.dart') ||
            exportPath.endsWith('.freezed.dart')) {
          continue;
        }

        final resolvedPath = getAbsoluteImportPath(file.path, exportPath);

        imports.add({
          'fileName': _getFileName(exportPath),
          'filePath': resolvedPath,
          'relativePath': exportPath,
        });
      }
    }

    return imports;
  }

  static String _getFileName(String path) {
    final segments = path.split('/');
    final fileName = segments.last;
    return fileName.replaceAll('.dart', '');
  }

  static String getAbsoluteImportPath(
      String currentFilePath, String relativeImportPath) {
    final currentFileUri = Uri.file(currentFilePath);
    final resolvedUri = currentFileUri.resolve(relativeImportPath);
    return resolvedUri.toFilePath();
  }

  static String getRules(String folder) {
    try {
      final libDirectory = Directory(folder);

      final file = File('${libDirectory.parent.path}/connection_rules.json');

      if (!file.existsSync()) {
        print('The connection_rules.yaml file does not exist.');
        return '';
      }

      return file.readAsStringSync();
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }
}
