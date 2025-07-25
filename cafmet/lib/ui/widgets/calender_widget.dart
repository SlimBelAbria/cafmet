import 'package:cafmet/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:csv/csv.dart'; 
import 'package:logger/logger.dart'; // For logging

// Google Sheets Service to fetch data
class GsheetService {
  final Logger _logger = Logger();

  // Fetch calendar data from Google Sheets
  Future<List<Map<String, String>>> fetchCalender(String csvUrl) async {
    try {
      // Validate the URL
      if (csvUrl.isEmpty || !Uri.parse(csvUrl).hasAbsolutePath) {
        throw Exception("Invalid URL: No host specified in URI");
      }

      _logger.d("Fetching data from Google Sheets CSV...");
      final response = await http.get(Uri.parse(csvUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.d("Data fetched successfully");
        final csvData = const CsvToListConverter().convert(response.body);
        _logger.d("CSV Data: $csvData"); // Log the CSV data

        List<Map<String, String>> events = [];

        for (int i = 1; i < csvData.length; i++) {
          final date = csvData[i][0]?.toString() ?? '22'; // Default to 22 if missing
          
          final title = csvData[i][3]?.toString() ?? 'No Title'; // Default title if missing

          events.add({
            "date": date,
           
            "title": title,
          });
        }
        _logger.d("Parsed Events: $events"); // Log the parsed events
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

// Calendar Widget
class CalenderWidget extends StatelessWidget {
  final String csvUrl;

  const CalenderWidget({required this.csvUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarGrid(csvUrl: csvUrl),
    );
  }
}

// Calendar Grid Stateful Widget
class CalendarGrid extends StatefulWidget {
  final String csvUrl;

 const CalendarGrid({required this.csvUrl, Key? key}) : super(key: key);

  @override
  CalendarGridState createState() => CalendarGridState();
}

class CalendarGridState extends State<CalendarGrid> {
   final List<String> _weekDays = ['Tue', 'Wed', 'Thu'];
  final List<int> _dates = [22, 23, 24]; // Example dates
  int _selectedDate = 22; // Selected date
  List<Event> allEvents = []; // Dynamic events list
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchCalendarData(); // Fetch data when the widget initializes
  }

  // Fetch calendar data from Google Sheets
  Future<void> _fetchCalendarData() async {
    final googleSheetsService = GsheetService();
    try {
      // Validate the URL before fetching data
      if (widget.csvUrl.isEmpty || !Uri.parse(widget.csvUrl).hasAbsolutePath) {
        throw Exception("Invalid URL: No host specified in URI");
      }

      final data = await googleSheetsService.fetchCalender(widget.csvUrl);
      setState(() {
        allEvents = data.map((event) {
          return Event(
            date: int.parse(event["date"] ?? '22'), // Extract day from date
            title: event["title"] ?? 'No Title',
           
            location: '', // Add location if available in CSV
            speaker: '', // Add speaker if available in CSV
            hasJoinButton: false, // Set based on your logic
            color: sColor, // Default color
          );
        }).toList();
        _isLoading = false; // Data fetched, stop loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading on error
        // Use fallback data if fetching fails
        allEvents = [
          Event(
            date: 22,
            title: 'Fallback Event 1',
           
            location: 'Room A',
            speaker: 'Speaker 1',
            hasJoinButton: true,
            color: Colors.blue[100]!,
          ),
          Event(
            date: 22,
            title: 'Fallback Event 2',
         
            location: 'Room B',
            speaker: 'Speaker 2',
            hasJoinButton: false,
            color: Colors.green[100]!,
          ),
        ];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: _weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Calendar grid
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = _dates[index];
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _dates[index] == _selectedDate
                          ? const Color(0xffEE751B) // Selected date color
                          : Colors.grey[300], // Light grey for unselected
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekDays[index],
                          style: TextStyle(
                            color: _dates[index] == _selectedDate
                                ? Colors.white // White text for selected date
                                : Colors.black54, // Light text for unselected
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _dates[index].toString(),
                          style: TextStyle(
                            color: _dates[index] == _selectedDate
                                ? Colors.white // White text for selected date
                                : Colors.black, // Dark text
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Display events for the selected date
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildEventList(),
          ),
        ],
      ),
    );
  }

  // Build the list of events for the selected date
  Widget _buildEventList() {
    // Filter events for the selected date
    final filteredEvents = allEvents.where((event) => event.date == _selectedDate).toList();

    return ListView.builder(
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        return _buildEventItem(context, filteredEvents[index]);
      },
    );
  }

  // Build a single event item
  Widget _buildEventItem(BuildContext context, Event event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: event.color, // Use the event's color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(
              color: Colors.black, // Dark text
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
        
          if (event.hasJoinButton) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xffEE751B), // Orange button
              ),
              child: const Text(
                'Join',
                style: TextStyle(
                  color: Colors.white, // White text
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Event class
class Event {
  final int date;
  final String title;

  final String location;
  final String speaker;
  final bool hasJoinButton;
  final Color color;

  Event({
    required this.date,
    required this.title,
   
    required this.location,
    required this.speaker,
    this.hasJoinButton = false,
    required this.color,
  });
}