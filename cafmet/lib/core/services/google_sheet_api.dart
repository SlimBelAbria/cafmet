import 'package:cafmet/core/constants.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "cafmet2025",
  "private_key_id": "c4cc20b688bd6a0693fb17825d0c3741a5045f8e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCoZOXzWa3M0dEw\n/BLLOI9BZ0ClWRQmvg+zgvKNaXaD9ChTLjGHU71NNdOGKw/v25dbC77nd3mWwoto\ngdcd0dG2SrlfQeqACUVPE0UK44yRAzjbVsXqUFjqTc2ItJr2cek9YfqFT/HWaEIT\nW+Y6gKGk1aYg+bD9Rmy0/0/ywfo0SYrJai8PcRWv8eAEKsFgqqQ+61QFpmI+81Jh\njGlGcx7zQFTHG8nwsoxr6Dgo85VmZI/xB+9wKIYVEdbS/4H54EKcwWtyQtprvp/W\nREF+wCDJ4GOtxOPLg2SIRYQqwH0UkSny++GjyHQ2ySkY8x9bSRITQs2515iB+mc3\nGBkJzpYjAgMBAAECggEAEE4ozUih4W3Fmup66rjwzM1HKgY3QyMZ2Rt1CggBZPiH\neQ/FgEw1oxwdqGWotuR6l43Kb+uWgehs4EiGQF8Yi9VYyruoDbrCvnaSs7cMiDQZ\ngB+QWBvB6E9yoenprAhOpIDFZb2JILuFU7jie51d9DHd0rPqv940WM2fUQBtuOc8\n8+3qrO4zPNV1zzHPeNQoFL0uOIzVSq4XPmJKgAc/t0CHqiwQyLVO3piPdRBbpr1d\nwgvV5MmqHBuSgIZDkochYQ0xvboNSyrlk3CP/dvaYCIg67q8HRq55ScNVDoasPNt\nbAK9W0aRusofW8+NhQ5hcb9sj++ItvbtibMQ5byJlQKBgQDoq+e94G1bKT/Hw86D\nhDM+wa6ko25uYRzid+AvdiVuZclqqGFzH0I8NnhR9vNiGQ9+0wfTNHbIrBMXotdt\nV4qoWBR3B6fiMI8WBcNTPLMzNy0BtZ8RwobSm3+29uMZu/G1gEeSmrRAjOqM7gvG\n/3bIeSSoe4MvDXzVDlWVzSQPzwKBgQC5Rydk3ZH6quvIr2Uw00bc1IFT4UdIMWxQ\nvJHTuTmQGQ5dyMH6l+GYe/oX5c2jHiwltVL3oAVmERIBZCcU5CuOoQ+tuKQIPp7Y\nDnnXEJraaVLdFyMajij+ICEipCaxFq/OFR5/3IZZAVes577ZZKBpeuKmR/zU0uWs\nAZc/0HI1bQKBgALloQ0MLlBkQxcJqRiaHMk7QCFsp4NYUjO/qlrs7apiOg/J6Oy2\nBu0ZAIaEvKMMDNVXa1GF5bS578LrlCMYY/GUpyyUO9LlJ+LuT3BJ4TFSDo1m5YQj\nF+qnZP+yM0GuxWOtJTb+FiB3oLQAgsUHiUMVvw8Z+pgrYtKESyyCUWChAoGAQS5X\nHZUVlioraR7LarHpbCcWmHvYp/07LewpIWM4bQljlHrcQ1zLcOmswluGTKyAu4Ne\n/N6/B3lZ7ENfvGnJKRRgf61Fh+D/4OK22oJs+Am1rTJGl0EMCtsizR0Sv5pLnySu\n5iye1xEx1xJwgep0xKcGtZj9yaGoSysEGt8qTsECgYAmyQeYVO2APXbrDzZ1wvXC\n45UqiET2Q3sNmVTXtHuPbuGMlzL/i2gKew5Ya6yyro5zfZiUkmzz/aiLkEpY7t+e\nNK2yq2xACli2vJAL8gUKeSxScydRWodxDSagd8rHAOgE6DHgqjbDrTpSR8yGXTQa\nTp4QB02Xh15t1WzvtVimyQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@cafmet2025.iam.gserviceaccount.com",
  "client_id": "117033828493427952746",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40cafmet2025.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? usersheet;

  // Add these new worksheet references
  static Worksheet? _attendanceSheet;
  static Worksheet? _mealSheet;

  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(csvId);
    usersheet = await _getworkseet(spreadsheet, title: 'notifications');
    
    // Initialize the additional sheets
    _attendanceSheet = await spreadsheet.worksheetById(566369401);
    _mealSheet = await spreadsheet.worksheetById(900036085);
    
    // Initialize headers if needed
    await _initSheet(_attendanceSheet!, ['Timestamp', 'id', 'Name', 'Session ID', 'Action']);
    await _initSheet(_mealSheet!, ['Timestamp', 'id', 'Name', 'Already Ate']);
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