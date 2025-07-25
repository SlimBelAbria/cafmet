import 'package:cafmet/ui/screens/home_screen.dart';
import 'package:cafmet/ui/screens/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:iconsax/iconsax.dart';

class ScanScreen extends StatefulWidget {
  final String? userRole; // Add userRole parameter
  const ScanScreen({Key? key, this.userRole}) : super(key: key);

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isCameraReady = false;
  bool isScanning = false; // To control whether scanning is active
  String? scannedData; // To store the scanned data
  bool isFlashOn = false; // To track the flashlight state

  @override
  void initState() {
    super.initState();
    checkCameraPermission();
  }

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (!mounted) return; // Check if the widget is still mounted

    if (status.isGranted) {
      setState(() {
        isCameraReady = true;
      });
    } else {
      setState(() {
        isCameraReady = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to scan QR codes.'),
          ),
        );
      }
    }
  }

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn; // Toggle flashlight state
    });
    cameraController.toggleTorch(); // Toggle the flashlight
  }

  void _startScan() {
    setState(() {
      isScanning = true; // Start scanning
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning || !mounted) return; // Only scan if isScanning is true

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (!mounted) return;

      setState(() {
        scannedData = barcode.rawValue;
        isScanning = false; // Stop scanning after a successful scan
      });

      // Turn off the flashlight after scanning
      if (isFlashOn) {
        _toggleFlash(); // Toggle the flashlight off
      }

      // Pass the scanned data to ViewScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewScreen(
            code: scannedData!, // Pass the scanned code
          ),
        ),
      );
      break; // Exit after processing the first valid barcode
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark AppBar
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            // Navigate back to HomePage with the userRole
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userRole: widget.userRole), // Pass userRole back
              ),
            );
          },
          icon: const Icon(Iconsax.arrow_left_2, weight: 8, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              isFlashOn ? Iconsax.flash_1 : Iconsax.flash_slash,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isCameraReady
          ? Stack(
              children: [
                // QR Scanner View
                MobileScanner(
                  controller: cameraController,
                  onDetect: _onDetect,
                ),

                // Red Crossed Lines (Centered)
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        // Horizontal Red Line
                        Center(
                          child: Container(
                            width: 200,
                            height: 2,
                            color: Colors.red,
                          ),
                        ),
                        // Vertical Red Line
                        Center(
                          child: Container(
                            width: 2,
                            height: 200,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Start Scan Button (Positioned at the bottom)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _startScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff285F74),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                      ),
                      child: const Text(
                        'Start Scan',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'Camera permission is required to scan QR codes.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
    );
  }
}