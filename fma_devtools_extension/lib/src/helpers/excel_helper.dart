import 'package:excel/excel.dart';

import '../../main.dart';

class ExcelHelper {
  create(MicroBoardData data) {
    final excel = Excel.createExcel();
    Sheet sheetObject = excel['Routes'];

    CellStyle cellStyleBold = CellStyle(bold: true);

    final headerTexts = ['Route', 'Description', 'MicroApp', 'Description'];

    for (var i = 0; i < headerTexts.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i))
        ..value = TextCellValue(headerTexts[i])
        ..cellStyle = cellStyleBold;
    }

    sheetObject.setColumnWidth(0, 30);
    sheetObject.setColumnWidth(1, 45);
    sheetObject.setColumnWidth(2, 15);
    sheetObject.setColumnWidth(3, 30);

    for (var app in data.microApps) {
      final pages = app.pages ?? [];
      for (var page in pages) {
        final microAppName = app.name;
        final microAppDescription = app.description;
        final route = page.route;
        final description = page.description;

        sheetObject.appendRow([
          TextCellValue(route),
          TextCellValue(description),
          TextCellValue(microAppName),
          TextCellValue(microAppDescription ?? ''),
        ]);
      }
    }

    excel.delete('Sheet1');

    excel.save(fileName: 'micro_app_routes.xlsx');
  }
}
