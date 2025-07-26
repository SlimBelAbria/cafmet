import 'package:cafmet/core/constants.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:io';

class GoogleSheetApi {
  // Replace hardcoded credentials with environment variable
  static const _credentials = String.fromEnvironment(
    'GOOGLE_SERVICE_ACCOUNT_CREDENTIALS',
    defaultValue: 'YOUR_GOOGLE_SERVICE_ACCOUNT_CREDENTIALS_HERE',
  );

  static final _gsheets = GSheets(_credentials);
  static Worksheet? usersheet;

  // Add these new worksheet references
  static Worksheet? _attendanceSheet;
  static Worksheet? _mealSheet;

  static Future init() async {
    // Check if credentials are properly configured
    if (_credentials == 'YOUR_GOOGLE_SERVICE_ACCOUNT_CREDENTIALS_HERE') {
      throw Exception(
        'Google Service Account credentials not configured. '
        'Please set the GOOGLE_SERVICE_ACCOUNT_CREDENTIALS environment variable '
        'or add it to your build configuration.'
      );
    }

    try {
      final spreadsheet = await _gsheets.spreadsheet(csvId);
      usersheet = await _getworkseet(spreadsheet, title: 'notifications');
      
      // Initialize the additional sheets
      _attendanceSheet = await spreadsheet.worksheetById(566369401);
      _mealSheet = await spreadsheet.worksheetById(900036085);
      
      // Initialize headers if needed
      await _initSheet(_attendanceSheet!, ['Timestamp', 'id', 'Name', 'Session ID', 'Action']);
      await _initSheet(_mealSheet!, ['Timestamp', 'id', 'Name', 'Already Ate']);
    } catch (e) {
      throw Exception('Failed to initialize Google Sheets API: $e');
    }
  }

  static Future<Worksheet> _getworkseet(
    Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<int> getRowCount() async {
    if (usersheet == null) return 0;
    final lastRow = await usersheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future insert(List<Map<String, dynamic>> rowlist) async {
    if (usersheet == null) return;
    
    for (var row in rowlist) {
      await usersheet!.values.map.appendRow(row);
    }
  }
  
  // Add these new methods without changing existing ones
  static Future<void> logAttendance({
    required String id,
    required String name,
    required String sessionId,
    required String action,
  }) async {
    await _attendanceSheet?.values.appendRow([
      DateTime.now().toIso8601String(),
      id,
      name,
      sessionId,
      action.toUpperCase(),
    ]);
  }

  static Future<bool> checkMealEligibility(String id) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final rows = await _mealSheet?.values.allRows() ?? [];

    for (final row in rows.skip(1)) {
      if (row.length >= 2 && row[1] == id) {
        final recordDate = row[0].toString().substring(0, 10);
        if (recordDate == today) return false;
      }
    }
    return true;
  }

  static Future<void> logMealCheckin({
    required String id,
    required String name,
  }) async {
    await _mealSheet?.values.appendRow([
      DateTime.now().toIso8601String(),
      id,
      name,
      'TRUE',
    ]);
  }

  static Future<void> _initSheet(Worksheet? sheet, List<String> headers) async {
    if (sheet == null) return;
    final firstRow = await sheet.values.row(1);
    if (firstRow.isEmpty) {
      await sheet.values.insertRow(1, headers);
    }
  }
}