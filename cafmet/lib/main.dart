
import 'package:cafmet/ui/screens/home_screen.dart';
import 'package:cafmet/ui/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:cafmet/core/services/google_sheet_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSheetApi.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
       theme: ThemeData(
        fontFamily: 'Montserrat', // Apply Montserrat globally
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),),
      home: const OnBoardScreen(),
     
    );
  }

}