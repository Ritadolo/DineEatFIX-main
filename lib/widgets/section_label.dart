import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final Color color;

  const SectionLabel(this.text,
      {Key? key, this.color = AppColors.textGray})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }
}
