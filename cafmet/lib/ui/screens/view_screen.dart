import 'package:cafmet/core/services/google_sheet_api.dart';
import 'package:cafmet/core/services/google_sheets_service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewScreen extends StatefulWidget {
  final String code;
  const ViewScreen({required this.code, Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late Future<Map<String, String>> _userFuture;
  String? _selectedProcess;
  String? _attendanceAction;
  String? _selectedSession = "S1";
  final List<String> _sessions = ["S1", "S2", "S3", "S4", "S5"];

  @override
  void initState() {
    super.initState();
    _userFuture = getUserDetails(widget.code);
    GoogleSheetApi.init().catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sheet initialization failed: $e')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.black87,
        foregroundColor: Color.fromARGB(221, 255, 255, 255),
        title: const Text(
          'Event Scanner',
           style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          )),),
      body: FutureBuilder<Map<String, String>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!;
          final fullName = '${user['Name']} ${user['LastName']}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // User Card
                _buildUserCard(fullName, user['Role'] ?? 'Unknown'),
                const SizedBox(height: 20),

                // Process Selection
                _buildProcessDropdown(),
                const SizedBox(height: 10),

                // Dynamic Controls
                if (_selectedProcess == 'attendance') ...[
                  _buildSessionDropdown(),
                  const SizedBox(height: 10),
                  _buildActionDropdown(),
                ],
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _handleSubmission(context, fullName),
                  child: const Text('Submit Record'
                  ),
                ),
                const SizedBox(height: 20),

                // QR Code Display
                QrImageView(
                  data: widget.code,
                  version: QrVersions.auto,
                  size: 120,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(String name, String role) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 30),
            ),
            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Text(role, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedProcess,
      decoration: const InputDecoration(
        labelText: 'Select Process',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'attendance', child: Text('Attendance')),
        DropdownMenuItem(value: 'meal', child: Text('Meal Check-in')),
      ],
      onChanged: (value) => setState(() => _selectedProcess = value),
    );
  }

  Widget _buildSessionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSession,
      decoration: const InputDecoration(
        labelText: 'Select Session',
        border: OutlineInputBorder(),
      ),
      items: _sessions.map((session) {
        return DropdownMenuItem(
          value: session,
          child: Text(session),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedSession = value),
    );
  }

  Widget _buildActionDropdown() {
    return DropdownButtonFormField<String>(
      value: _attendanceAction,
      decoration: const InputDecoration(
        labelText: 'Select Action',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'IN', child: Text('Check In')),
        DropdownMenuItem(value: 'OUT', child: Text('Check Out')),
      ],
      onChanged: (value) => setState(() => _attendanceAction = value),
    );
  }

  Future<void> _handleSubmission(BuildContext context, String fullName) async {
    if (_selectedProcess == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a process')));
      return;
    }

    try {
      if (_selectedProcess == 'attendance') {
        if (_selectedSession == null || _attendanceAction == null) {
          throw Exception('Please select both session and action');
        }
        await GoogleSheetApi.logAttendance(
          id: widget.code,
          name: fullName,
          sessionId: _selectedSession!,
          action: _attendanceAction!,
        );
        _showSuccessDialog(context, 'Attendance recorded successfully');
      } else {
        final canEat = await GoogleSheetApi.checkMealEligibility(widget.code);
        if (!canEat) {
          _showErrorDialog(context, message: 'This attendee has already eaten today');
          return;
        }
        await GoogleSheetApi.logMealCheckin(
          id: widget.code,
          name: fullName,
        );
        _showSuccessDialog(context, 'Meal check-in recorded');
      }
    } catch (e) {
      _showErrorDialog(context, message: 'Failed to record: ${e.toString()}');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 10),
              const Text(
                "Success",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, size: 80, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                "Error",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  
  Future<Map<String, String>> getUserDetails(String scannedId) async {
    // Your existing implementation
    final googleSheetsService = GoogleSheetsService();
    String csvUrl = const String.fromEnvironment(
      'GOOGLE_SHEETS_USER_URL',
      defaultValue: 'YOUR_GOOGLE_SHEETS_USER_URL_HERE',
    );

    try {
      final data = await googleSheetsService.fetchSheetData(csvUrl);
      if (data.isEmpty || data.length < 2) throw Exception("No data");

      final headers = data[0].map((h) => h.trim().toLowerCase()).toList();
      final idIndex = headers.indexOf("id");
      final roleIndex = headers.indexOf("institute");
      final nameIndex = headers.indexOf("name");
      final lastNameIndex = headers.indexOf("lastname");

      for (var i = 1; i < data.length; i++) {
        final row = data[i];
        if (row.length > idIndex && row[idIndex].toString().trim() == scannedId) {
          return {
            "id": scannedId,
            "Role": row[roleIndex].toString().trim(),
            "Name": row[nameIndex].toString().trim(),
            "LastName": row[lastNameIndex].toString().trim(),
          };
        }
      }
      throw Exception("User not found");
    } catch (e) {
      return {};
    }
  }
}