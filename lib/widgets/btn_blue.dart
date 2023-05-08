import 'package:flutter/material.dart';

class BtnBlue extends StatelessWidget {

  final String text;
  final Function()? onPressed;
  
  const BtnBlue({
    super.key, 
    required this.text, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return 
    ElevatedButton( 
      style: ElevatedButton.styleFrom( 
        elevation: 2, 
        backgroundColor: Colors.blue, 
        shape: const StadiumBorder(), 
      ), 
      onPressed: onPressed,
      child: Container(
        height: 55,
        width: double.infinity,
        child: Center(
          child: Text(text, style: const TextStyle( color: Colors.white, fontSize: 15 )),
        ),
      ),
    );
  }
}