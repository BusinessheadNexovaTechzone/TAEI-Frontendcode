import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

class ExcelDownloadHelper {
  // static Future<void> downloadExcel({
  //   required List<String> headers,
  //   required List<Map<String, dynamic>> data,
  //   String fileName = "report.xlsx",
  // }) async {
  //   final excel = Excel.createExcel();
  //   final sheet = excel['Sheet1'];

  //   /// ---------------- HEADER ----------------
  //   sheet.appendRow(headers.map(toCellValue).toList());

  //   /// ---------------- DATA ----------------
  //   for (int i = 0; i < data.length; i++) {
  //     final row = [
  //       toCellValue(i + 1), // S.No
  //       ...headers.skip(1).map((key) => toCellValue(data[i][key]))
  //     ];
  //     sheet.appendRow(row);
  //   }

  //   /// ---------------- TOTAL ROW ----------------
  //   final Map<String, num> totals = {};

  //   for (var key in headers.skip(1)) {
  //     num total = 0;
  //     for (var row in data) {
  //       final parsed = num.tryParse(row[key]?.toString() ?? "");
  //       if (parsed != null) total += parsed;
  //     }
  //     totals[key] = total;
  //   }

  //   sheet.appendRow([
  //     TextCellValue("TOTAL"),
  //     ...headers
  //         .skip(1)
  //         .map((key) => toCellValue(totals[key] == 0 ? "" : totals[key]))
  //   ]);

  //   final bytes = excel.encode()!;

  //   if (kIsWeb) {
  //     _downloadExcelWeb(Uint8List.fromList(bytes), fileName);
  //   } else {
  //     await _downloadExcelMobile(Uint8List.fromList(bytes), fileName);
  //   }
  // }
  static Future<void> downloadExcel({
    required List<String> headers,
    required List<Map<String, dynamic>> data,
    String fileName = "report.xlsx",
  }) async {
    // log(data.toList().toString());
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    /// ---------------- ADD DEFAULT S.NO ----------------
    final List<String> finalHeaders = [
      "S.No",
      ...headers.map((e) => e.replaceAll("_", " ").toUpperCase()).toList(),
    ];

    /// ---------------- HEADER ----------------
    sheet.appendRow(finalHeaders.map(toCellValue).toList());

    /// ---------------- DATA ----------------
    for (int i = 0; i < data.length; i++) {
      log(data[i].toString());
      final row = [
        toCellValue(i + 1), // Auto S.No
        ...headers.map((key) => toCellValue(data[i][key])),
      ];
      sheet.appendRow(row);
    }

    /// ---------------- TOTAL ROW ----------------
    final Map<String, num> totals = {};

    for (var key in headers) {
      num total = 0;
      for (var row in data) {
        final parsed = num.tryParse(row[key]?.toString() ?? "");
        if (parsed != null) total += parsed;
      }
      totals[key] = total;
    }

    sheet.appendRow([
      TextCellValue("TOTAL"),
      ...headers.map(
        (key) => toCellValue(totals[key] == 0 ? "" : totals[key]),
      ),
    ]);

    final bytes = excel.encode()!;
    final Uint8List uint8List = Uint8List.fromList(bytes);

    if (kIsWeb) {
      _downloadExcelWeb(uint8List, fileName);
    } else {
      await _downloadExcelMobile(uint8List, fileName);
    }
  }

  /// ================= MOBILE =================

  static Future<void> _downloadExcelMobile(
      Uint8List bytes, String fileName) async {
    Directory directory;

    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) return;

      directory = (await getExternalStorageDirectory())!;
    } else {
      // iOS SAFE PATH
      directory = await getApplicationDocumentsDirectory();
    }

    final file = File("${directory.path}/$fileName");
    log(file.path);
    await file.writeAsBytes(bytes);
  }

  /// ================= WEB =================
  static void _downloadExcelWeb(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}

CellValue toCellValue(dynamic value) {
  if (value == null) {
    return TextCellValue('');
  }
  if (value is int) {
    return IntCellValue(value);
  }
  if (value is double) {
    return DoubleCellValue(value);
  }
  if (value is num) {
    return DoubleCellValue(value.toDouble());
  }
  return TextCellValue(value.toString());
}
