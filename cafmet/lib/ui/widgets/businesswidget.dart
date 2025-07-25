import 'package:cafmet/core/services/google_sheets_service.dart';
import 'package:cafmet/ui/widgets/calender_widget.dart';
import 'package:flutter/material.dart';

class B2BWidget extends StatefulWidget {
  const B2BWidget({super.key});

  @override
  B2BWidgetState createState() => B2BWidgetState();
}

class B2BWidgetState extends State<B2BWidget> {
  final GoogleSheetsService googleSheetsService = GoogleSheetsService();

  @override
  
  Widget build(BuildContext context) {
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const SizedBox(height: 50),
            const Text(
              "B2B Session Plan",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 20),
          Expanded(
  child: ListView.builder(
    itemCount: 6,
    itemBuilder: (context, row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (col) {
          return FutureBuilder(
            future: googleSheetsService.fetchB2Bdata("${row+1},${col+1}"),
            builder: (context, snapshot) {
              String company = 'placeholder';
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                company = snapshot.data![0]["company"] ?? 'placeholder';
              }
              return GestureDetector(
                onTap: () => _showSeatDialog(row + 1, col + 1),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
  'assets/$company.jpg',
  width: 50,
  height: 50,
  errorBuilder: (context, error, stackTrace) => 
    Image.asset('assets/armchair.png', width: 50, height: 50),
),
                ),
              );
            },
          );
        }),
      );
    },
  ),
),
          ],
        ),
      ),
    );
  }

  void _showSeatDialog(int row, int col) async {
    List<String> seatLabels = ['A', 'B', 'C', 'D','E','F'];
    try {
      List<Map<String, String>> b2bdata = await googleSheetsService.fetchB2Bdata("$row,$col");
      
      String company = b2bdata.isNotEmpty ? b2bdata[0]["company"] ?? 'Unknown Company' : 'no_data';
      String calender = b2bdata.isNotEmpty ? b2bdata[0]["calender"] ?? 'No data' : 'No data';

      if (!mounted) return;
      _displaySeatDialog(context, seatLabels[row-1], col, company, calender);
    } catch (e) {
      if (!mounted) return;
      _displayErrorDialog(context);
    }
  }

  void _displaySeatDialog(BuildContext context, String seatRow, int col, String company, String calender) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Icon(Icons.business_center, color: Colors.blueGrey),
              const SizedBox(width: 10),
              Text("Seat $seatRow$col", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Business Information:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/$company.jpg', width: 300, height: 300),
                    const SizedBox(height: 4),
                    Text("Company: $company", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CalenderWidget(csvUrl: calender),
                  ),
                );
              },
              child: const Text("Check Schedule", style: TextStyle(fontSize:14,color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close", style: TextStyle(fontSize:14,color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  void _displayErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title:const Row(
            children:  [
              Icon(Icons.error_outline, color: Colors.redAccent),
              SizedBox(width: 10),
              Text("Error", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
            ],
          ),
          content: const Text("Unable to retrieve data. Please try again later.",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }
}