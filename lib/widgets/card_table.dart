import 'dart:ui';

import 'package:flutter/material.dart';

class CardTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      //opciones disponible app
      children: [
        TableRow(children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'map');
            },
            child: const _SigleCard(
              color: Color.fromARGB(255, 34, 188, 85),
              icon: Icons.map_sharp,
              text: 'Mapa',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'paises');
            },
            child: const _SigleCard(
              color: Colors.pinkAccent,
              icon: Icons.hotel_sharp,
              text: 'Hoteles',
            ),
          ),
        ]),
        TableRow(children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'marcadores');
            },
            child: const _SigleCard(
              color: Color.fromARGB(255, 203, 186, 0),
              icon: Icons.star_purple500_outlined,
              text: 'Marcadores favoritos',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'reservas');
            },
            child: const _SigleCard(
              color: Color.fromARGB(255, 203, 186, 0),
              icon: Icons.hotel_rounded,
              text: 'Mis reservas hotel',
            ),
          ),
        ]),
      ],
    );
  }
}

class _SigleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _SigleCard(
      {Key? key, required this.icon, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: this.color,
          child: Icon(
            this.icon,
            size: 35,
            color: Colors.white,
          ),
          radius: 30,
        ),
        SizedBox(height: 10),
        Text(
          this.text,
          style: TextStyle(color: this.color, fontSize: 18),
        )
      ],
    ));
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(62, 66, 107, 0.7),
                borderRadius: BorderRadius.circular(20)),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
