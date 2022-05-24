import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultHeaderTitle extends StatelessWidget {
  final String title;
  const DefaultHeaderTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black)),
    );
  }
}
