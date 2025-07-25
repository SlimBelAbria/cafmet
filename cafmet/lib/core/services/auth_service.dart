import 'package:flutter/material.dart';
import 'package:cafmet/core/services/google_sheets_service.dart';

class AuthService {
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();
  final String _csvUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vS3s2CodS5ElcAHye4YBwyQV5i7ZwuNiySbNMFagMRImyeMnsTSa1Ps32WZrM91qGHuNb7VwiaTln1t/pub?gid=0&single=true&output=csv';

  // Method to fetch users from Google Sheets
  Future<List<Map<String, String>>> fetchUsers() async {
    final sheetData = await _googleSheetsService.fetchSheetData(_csvUrl);
    final List<Map<String, String>> users = [];

    // Assuming the first row contains headers (e.g., 'username', 'password', 'role')
    for (var i = 1; i < sheetData.length; i++) {
      final row = sheetData[i];
      if (row.length >= 3) { // Ensure the row has at least 3 columns (username, password, role)
        users.add({
          'username': row[0].trim(), // Trim to remove extra spaces
          'password': row[1].trim(), // Trim to remove extra spaces
          'role': row[2].trim(), // Role of the user
        });
      }
    }

    return users;
  }

  // Method to handle login logic and routing
  Future<Map<String, String>?> login(String username, String password, BuildContext context) async {
    try {
      // Fetch users from Google Sheets
      final users = await fetchUsers();

      // Check if the entered credentials match any user
      final user = users.firstWhere(
        (user) => user['username']?.toLowerCase() == username.toLowerCase() && 
                  user['password'] == password,
        orElse: () => {}, // Return an empty map if no match is found
      );

      if (user.isNotEmpty) {
        return user; // Return the user data (including role)
      } else {
        // Show an error dialog if login fails
       
        return null; // Login failed
      }
    } catch (e) {
      // Handle errors (e.g., network issues, invalid CSV format)
      
      return null; // Login failed
    }
  }
}