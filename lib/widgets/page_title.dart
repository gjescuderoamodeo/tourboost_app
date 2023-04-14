import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 20 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const[
            //poner aquí logo
             Text('TourBoost', style: TextStyle( fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white )),
          ],
        ),
      ),
    );
  }
}