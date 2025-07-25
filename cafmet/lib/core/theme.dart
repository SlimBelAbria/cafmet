import 'package:flutter/material.dart';


const Color breakColor = Color(0xffE8E8E8);
const Color openColor = Color(0xFFBBDEFB);
const Color cpColor=Color(0xff87BFCF );
const Color pColor =Color(0xFFFFCDD2);
const Color sColor = Color(0xFFE5E5E5);
const Color tColor = Color(0xFFD1C4E9);
const Color lunchColor=Color(0xFFF8BBD0);
const Color forummesureColor=Color(0xFF5E91A1);
const Color primaryColor =  Color(0xFF2E7D32); 
const Color secondaryGreen=Color(0xffC0E218);


class AppColors {
  const AppColors._();

  static const Color darkBlue = Color(0xff1E2E3D);
  static const Color darkerBlue = Color(0xff152534);
  static const Color darkestBlue = Color(0xff0C1C2E);

  static const List<Color> defaultGradient = [
    darkBlue,
    darkerBlue,
    darkestBlue,
  ];
}



class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.children,
    this.colors = AppColors.defaultGradient,
    super.key,
  });

  final List<Color> colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}