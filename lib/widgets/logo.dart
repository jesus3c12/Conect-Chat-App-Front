import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String titulo;
  const Logo({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        margin: const EdgeInsets.only( top: 70 ),
        child: Column(
          children: <Widget> [

            const Image( image: AssetImage('assets/conect_logo.png') ),
            const SizedBox( height:  15 ),
            Text(titulo, 
            style: const TextStyle(
              fontSize: 25, 
              color: Colors.blue,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 0.0,
                  color: Colors.black,
                  ),
                  //Shadow(
                    //offset: Offset(10.0, 10.0),
                    //blurRadius: 8.0,
                    //color: Color.fromARGB(125, 0, 0, 255),
                  //),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}