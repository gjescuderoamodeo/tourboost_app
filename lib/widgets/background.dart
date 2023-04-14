import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 2],
        colors: [
          Color.fromARGB(246, 49, 53, 185),
          Color.fromARGB(255, 43, 55, 122),
        ]
      )
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // gradiante morado
        Container(decoration: boxDecoration ),
        // caja fondo
        Positioned(
          top: -10,
          left: -10,
          child: _PinkBox()
        ),
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          gradient:const LinearGradient(
            colors:[
              Color.fromRGBO(236, 148, 98, 1),
              Color.fromRGBO(241, 142, 172, 1),
            ]
          )
        ),
      ),
    );
  }
}