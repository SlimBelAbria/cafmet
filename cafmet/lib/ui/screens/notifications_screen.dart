import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:cafmet/core/services/google_sheet_api.dart';

class NotificationsWidget extends StatefulWidget {
  final String csvUrl;
  final String? userRole;

  const NotificationsWidget({Key? key, required this.csvUrl, this.userRole}) : super(key: key);

  @override
  NotificationsWidgetState createState() => NotificationsWidgetState();
}

class NotificationsWidgetState extends State<NotificationsWidget> {
  late Future<List<Map<String, String>>> notificationsFuture;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    notificationsFuture = _fetchNotifications();
    _startSearchTimer();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  void _startSearchTimer() {
    _searchTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final newNotifications = await _fetchNotifications();
        setState(() {
          notificationsFuture = Future.value(newNotifications);
        });
      } catch (e) {
        //e
      }
    });
  }

  Future<List<Map<String, String>>> _fetchNotifications() async {
    await GoogleSheetApi.init();
    final rows = await GoogleSheetApi.usersheet!.values.allRows();
    if (rows.length <= 1) {
      return [];
    }
    return rows.sublist(1).map((row) => {
      "type": row[2],
      "title": row[0],
      "message": row[1],
    }).toList();
  }

  Widget _getNotificationIcon(String type) {
    switch (type) {
      case 'System':
        return SvgPicture.asset('assets/system.svg', colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn), width: 24, height: 24);
      case 'Reminder':
        return SvgPicture.asset('assets/reminder.svg', colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn), width: 24, height: 24);
      case 'Event':
        return SvgPicture.asset('assets/event.svg', colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn), width: 24, height: 24);
      default:
        return SvgPicture.asset('assets/error.svg', colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn), width: 24, height: 24);
    }
  }

  Future<void> _addNotification() async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String? selectedType;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Notification",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: "Message",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.message),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Type",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: ['System', 'Reminder', 'Event'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await GoogleSheetApi.insert([
                          {
                            "type": selectedType,
                            "title": titleController.text,
                            "message": messageController.text,
                          }
                        ]);
                        setState(() {
                          notificationsFuture = _fetchNotifications();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        
        backgroundColor: Colors.black87,
        foregroundColor: const Color.fromARGB(221, 255, 255, 255),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications available"));
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(context, notification);
            },
          );
        },
      ),
      floatingActionButton: widget.userRole?.toLowerCase() == 'admin'
          ? FloatingActionButton.extended(
              onPressed: _addNotification,
              label: const Text("Add Notification"),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.orange,
            )
          : null,
    );
  }
Widget _buildNotificationCard(BuildContext context, Map<String, String> notification) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
          notification["title"] ?? "N/A",
          style:const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
            
          ],
        ),
      ),
      ListTile(
        leading: _getNotificationIcon(notification["type"] ?? 'default'),
       
        subtitle: Text( notification["message"] ?? "N/A",
          style:const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const SizedBox(), // Empty trailing widget
      ),
      const Divider(),
    ],
  );
}}