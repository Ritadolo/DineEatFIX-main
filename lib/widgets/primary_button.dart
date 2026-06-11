import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? leadingIcon;
  final VoidCallback? onTap;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.icon,
    this.leadingIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.champagneGold,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
