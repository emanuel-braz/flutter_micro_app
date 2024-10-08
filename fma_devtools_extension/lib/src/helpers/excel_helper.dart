import 'package:excel/excel.dart';
import 'package:fma_devtools_extension/src/controllers/fma_controller.dart';

class ExcelHelper {
  create() {
    final excel = Excel.createExcel();
    Sheet sheetObject = excel['Routes'];

    CellStyle cellStyleBold = CellStyle(bold: true);

    final headerTexts = [
      'Route',
      'Parameters',
      'Description',
      'MicroApp',
      'Description'
    ];

    for (var i = 0; i < headerTexts.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i))
        ..value = TextCellValue(headerTexts[i])
        ..cellStyle = cellStyleBold;
    }

    sheetObject.setColumnWidth(0, 30);
    sheetObject.setColumnWidth(1, 30);
    sheetObject.setColumnWidth(2, 45);
    sheetObject.setColumnWidth(3, 15);
    sheetObject.setColumnWidth(4, 30);

    for (var app in FmaController().value.microBoardData.microApps) {
      final pages = app.pages;
      for (var page in pages) {
        final microAppName = app.name;
        final pageParameters = page.parameters;
        final microAppDescription = app.description;
        final route = page.route;
        final routeDescription = page.description;

        sheetObject.appendRow([
          TextCellValue(route),
          TextCellValue(pageParameters),
          TextCellValue(routeDescription),
          TextCellValue(microAppName),
          TextCellValue(microAppDescription),
        ]);
      }
    }

    excel.delete('Sheet1');

    excel.save(fileName: 'micro_app_routes.xlsx');
  }
}
