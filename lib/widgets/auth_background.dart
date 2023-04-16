import 'package:flutter/material.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 50, top: 70),
          child: Row(
            children: [
              Text(
                "TourBoost",
                style: AppTheme.logoStyle,
              ),
              const Icon(Icons.tour_outlined, color: Colors.white, size: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [],
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
      gradient: LinearGradient(
          colors: [AppTheme.primary, Color.fromARGB(255, 37, 5, 167)]));
}
