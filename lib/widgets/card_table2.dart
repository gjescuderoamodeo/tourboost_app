import 'dart:ui';

import 'package:flutter/material.dart';

class CardTable2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      //opciones disponible app
      children: [
        TableRow(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'adminhotel');
              },
              child: const _SigleCard(
                color: Color.fromARGB(255, 34, 188, 85),
                icon: Icons.hotel,
                text: 'Administración Hoteles',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'adminpais');
              },
              child: const _SigleCard(
                color: Colors.pinkAccent,
                icon: Icons.public,
                text: 'Administración Paises',
              ),
            ),
          ],
        ),
        TableRow(children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'adminmarcadores');
            },
            child: const _SigleCard(
              color: Color.fromARGB(255, 239, 221, 23),
              icon: Icons.star_purple500_outlined,
              text: 'Administración Lugares',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'adminrecomendacion');
            },
            child: const _SigleCard(
              color: Color.fromARGB(255, 198, 73, 212),
              icon: Icons.event_available_rounded,
              text: 'Administración recomendación',
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
