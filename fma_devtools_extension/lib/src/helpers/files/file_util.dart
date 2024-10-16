import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:dtd/dtd.dart';

class FileUtils {
  // Ex: "lib/main.dart"
  static Future<void> writeToFile(String filePath, String content) async {
    if (dtdManager.hasConnection) {
      var rootPath = await getRootFilePath();
      await dtdManager.connection.value
          ?.writeFileAsString(Uri.file('$rootPath/$filePath'), content);
    }
  }

  static Future<FileContent?> readFromFile(String filePath) async {
    if (dtdManager.hasConnection) {
      var rootPath = await getRootFilePath();
      return dtdManager.connection.value
          ?.readFileAsString(Uri.file('$rootPath/$filePath'));
    } else {
      return null;
    }
  }

  static Future<String> getRootFilePath() async {
    if (dtdManager.hasConnection) {
      final conn = dtdManager.connection.value as DartToolingDaemon;

      final roots = await conn.getIDEWorkspaceRoots();
      final filePath = roots.ideWorkspaceRoots.first.toFilePath();
      return filePath;
    }
    return '';
  }
}
