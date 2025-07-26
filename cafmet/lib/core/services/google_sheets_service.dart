import 'package:cafmet/core/constants.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:csv/csv.dart'; // Import for CSV parsing
import 'package:logger/logger.dart'; // Import for logging
class GoogleSheetsService {
  final Logger _logger = Logger();

  // Fetch data from Google Sheets
  Future<List<List<String>>> fetchSheetData(String csvUrl) async {
    try {
      _logger.d("Fetching data from Google Sheets CSV...");
      final response = await http.get(Uri.parse(csvUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.d("Data fetched successfully");
        final csvData = const CsvToListConverter().convert(response.body);
        return csvData.map((row) => row.map((cell) => cell.toString()).toList()).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error fetching data: $e");
      rethrow;
    }
  }
  
   Future<List<Map<String, String>>> fetchNotifications() async {
  try {
    _logger.d("Fetching data from Google Sheets CSV...");
    final response = await http.get(Uri.parse(csvUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      _logger.d("Data fetched successfully");
      final csvData = const CsvToListConverter().convert(response.body);
      List<Map<String, String>> notifications = [];

      for (int i = 1; i < csvData.length; i++) {
        notifications.add({
          "title": csvData[i][0]?.toString() ?? 'No Title', // Use "title"
          "message": csvData[i][1]?.toString() ?? 'No Message', // Use "message"
          "type": csvData[i][2]?.toString() ?? 'No Time', // Use "type"
          "time": DateTime.now().toIso8601String(),
        });
      }
      return notifications;
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    _logger.e("Error fetching data: $e");
    rethrow;
  }
}
 Future<List<Map<String, String>>> fetchB2Bdata(String position) async {
 
  try {
    _logger.d("Fetching data from Google Sheets CSV...");
    final b2bUrl = const String.fromEnvironment(
      'GOOGLE_SHEETS_B2B_URL',
      defaultValue: 'YOUR_GOOGLE_SHEETS_B2B_URL_HERE',
    );
    final response = await http.get(Uri.parse(b2bUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      _logger.d("Data fetched successfully");
      final csvData = const CsvToListConverter().convert(response.body);
      List<Map<String, String>> notifications = [];

      for (int i = 1; i < csvData.length; i++) {
        
        if(csvData[i][2]==position){
           notifications.add({
          "name": csvData[i][0]?.toString() ?? 'No name', // Use "title"
          "contact_email": csvData[i][1]?.toString() ?? 'No info', // Use "message"
           "company": csvData[i][3]?.toString() ?? '',
            "calender": csvData[i][4]?.toString() ?? '', // Photo URL
            
        });
 }
      }
      return notifications;
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    _logger.e("Error fetching data: $e");
    rethrow;
  }
} Future<List<Map<String, String>>> fetchCalender(String csvUrl) async {
    try {
      _logger.d("Fetching data from Google Sheets CSV...");
      final response = await http.get(Uri.parse(csvUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.d("Data fetched successfully");
        final csvData = const CsvToListConverter().convert(response.body);
        List<Map<String, String>> events = [];

        for (int i = 1; i < csvData.length; i++) {
          events.add({
            "start": csvData[i][0]?.toString() ?? 'No start time', // Start time
            "end": csvData[i][1]?.toString() ?? 'No end time', // End time
            "title": csvData[i][2]?.toString() ?? 'No title', // Event title
          });
        }
        return events;
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error fetching data: $e");
      rethrow;
    }
  }
}

