import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String rute;
  final String tittle;
  final String subtittle;

  const Labels({super.key, required this.rute, required this.tittle, required this.subtittle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget> [
          Text(tittle, 
          style: const TextStyle( 
            color: Colors.black54, 
            fontSize: 15, 
            fontWeight: FontWeight.w300 
            ) 
          ),
          const SizedBox( height: 10 ),
          GestureDetector(
            child: Text( subtittle, 
            style: const TextStyle( 
              color: Colors.blue, 
              fontSize: 18, 
              fontWeight: FontWeight.bold 
              )
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, rute);
            },
          )
        ],
      ),
    );
  }
}
