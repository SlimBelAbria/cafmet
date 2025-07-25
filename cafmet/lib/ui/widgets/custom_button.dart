import 'package:cafmet/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoneButton extends StatelessWidget{
  const DoneButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        minimumSize: const Size(250, 50), // Set the button size
        textStyle: const TextStyle(fontSize: 16, color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
     
      child:  const Text('DONE ✅',style: TextStyle(fontFamily: 'MontserratFont'),),
    );
  }
}


class CreateButton extends StatelessWidget {
   final VoidCallback onPressed;
 

  
  final String buttonText;
  const CreateButton({
    required this.onPressed,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return    ElevatedButton(
                    onPressed:  onPressed,
                    
                   
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor:const Color(0xff285F74),
                      minimumSize: const Size(250, 50), // Set the button size
                      textStyle: const TextStyle(fontSize: 16,color:Color(0xff285F74),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                     child: Text(buttonText,style: const TextStyle(fontFamily: 'MontserratFont'),),
                  );
  }
}


class CalenderButton extends StatelessWidget {
   final VoidCallback onPressed;
 

  
  final String buttonText;
  const CalenderButton({
    required this.onPressed,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return    ElevatedButton.icon(
                    onPressed:  onPressed,
                    label: Text(buttonText,style:const TextStyle(fontFamily: 'MontserratFont'),),
                    icon: SvgPicture.asset('assets/bolt.svg', width: 32,colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                    style: ElevatedButton.styleFrom(
                      padding:const EdgeInsets.all(16),
                      backgroundColor:const Color(0xff285F74),
                      minimumSize: const Size(50, 50), // Set the button size
                      textStyle: const TextStyle(fontSize: 16,color:Color(0xff285F74),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
  }
}

class LoginButton extends StatelessWidget{
  final String buttonText;
  final double buttonTextSize;
  final Widget nextPage;
  const LoginButton({
    super.key,
    required this.nextPage,
    required this.buttonText,
    required this.buttonTextSize
  });
  @override
  Widget build(BuildContext context) {
    return(GestureDetector(
      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => nextPage, // Replace NextPage with your target page
                      ),
                    );
                  },
      child: Text(buttonText,style:  TextStyle(fontFamily:'MontserratFont',color:Colors.blue, fontSize: buttonTextSize, fontWeight:FontWeight.w300),),
    ));
  }

}


class CustomGreenButton extends StatelessWidget {
  final String label;
  final String subLabel;
  final String iconPath;
  final VoidCallback onPressed;

  const CustomGreenButton({
    super.key,
    required this.label,
    required this.subLabel,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient:const LinearGradient(
            colors: [primaryColor, secondaryGreen],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding:const EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 32),
          const  SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:const TextStyle(
                    fontFamily: 'MontserratFont',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subLabel,
                  style:const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
