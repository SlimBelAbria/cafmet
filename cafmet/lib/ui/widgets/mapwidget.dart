import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title & Location
           const Text(
              "Hotel's Location",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
           const Text(
              "Yassmine Hammamet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Map Section
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:const GoogleMap(
                  initialCameraPosition:  CameraPosition(
                    target: LatLng(36.3631335, 10.5333765),
                    zoom: 16,
                  ),
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Service Buttons (Glovo & Bolt)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildServiceButton(
                  icon: Icons.delivery_dining,
                  label: "Glovo",
                  color:const Color.fromARGB(255, 255, 194, 51),
                  url: 'x',
                ),
                _buildServiceButton(
                  icon: Icons.directions_car,
                  label: "Bolt",
                  color: const Color(0xff2A9C64),
                  url: 'x',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton({
    required IconData icon,
    required String label,
    required Color color,
    required String url,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 40, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style:const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
