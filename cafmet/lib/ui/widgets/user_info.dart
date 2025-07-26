import 'package:cafmet/core/services/google_sheets_service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserBadgeScreen extends StatelessWidget {
  final String user; // This is the user ID
  final String role;
  
  const UserBadgeScreen({
    super.key,
    required this.user,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getUserDetails(user),
      builder: (context, snapshot) {
        final name = snapshot.hasData 
            ? '${snapshot.data!['Name']} ${snapshot.data!['LastName']}'
            : 'Loading...';
            
        return Scaffold(
         
          body:Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:const AssetImage('assets/background.jpg'), // Your background image path
                fit: BoxFit.cover, // Cover the entire screen
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), // Optional: Add a dark overlay
                  BlendMode.darken,
                ),
              ),
            ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                minWidth: 300, // Minimum width
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(name, style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold)),
                      Text(snapshot.data!['institute'] ?? '' , style: const TextStyle(
                        fontSize: 16, 
                        color: Colors.grey)),
                      const SizedBox(height: 24),
                      QrImageView(
                        data: snapshot.data!['UserId'] ?? '' ,// Using the user ID for QR code
                        version: QrVersions.auto,
                        size: 160.0,
                      ),
                      const SizedBox(height: 8),
                      Text(snapshot.data!['UserId'] ?? '', 
                        style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        );
      },
    );
  }
}

Future<Map<String, String>> getUserDetails(String user) async {
  final googleSheetsService = GoogleSheetsService();
  String csvUrl = const String.fromEnvironment(
    'GOOGLE_SHEETS_USER_URL',
    defaultValue: 'YOUR_GOOGLE_SHEETS_USER_URL_HERE',
  );
  
  try {
    final data = await googleSheetsService.fetchSheetData(csvUrl);
    
    if (data.isEmpty || data.length < 2) {
      throw Exception("CSV data is empty or incomplete");
    }

    // Extract headers from the first row
    final headers = data[0].map((h) => h.trim().toLowerCase()).toList();

    // Get correct column indexes
    final idIndex = headers.indexOf("id");
    final roleIndex = headers.indexOf("role");
    final nameIndex = headers.indexOf("name");
    final usernameIndex = headers.indexOf("username");
    final lastNameIndex = headers.indexOf("lastname");
    final instituteIndex = headers.indexOf("institute");

    // Ensure required columns exist
    if (idIndex == -1 || roleIndex == -1 || nameIndex == -1 || lastNameIndex == -1 || usernameIndex == -1 || instituteIndex == -1) {
      throw Exception("CSV does not have the required columns: role, id, name, lastName");
    }

    // Iterate through rows, starting from row 1
    for (var i = 1; i < data.length; i++) {
      final row = data[i];

      if (row.length < headers.length) {
        continue;
      }

      final username = row[usernameIndex].toString().trim();

      if (username == user) {
        final institute = row[instituteIndex].toString().trim();
        final id = row[idIndex].toString().trim();
        final role = row[roleIndex].toString().trim();
        final name = row[nameIndex].toString().trim();
        final lastName = row[lastNameIndex].toString().trim();
        

        return {
          "Role": role,
          "Name": name,
          "LastName": lastName,
          "UserId": id,
          "institute": institute,
        };
      }
    }

    throw Exception("User with ID $user not found");
  } catch (e) {
    debugPrint("Error fetching or processing CSV data: $e");
    return {}; // Return an empty map to avoid crashing
  }
}