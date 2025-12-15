import 'package:flutter/material.dart';

class AppFloatingButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final double elevation;

  const AppFloatingButton({
    super.key,
    required this.onTap,
    this.size = 60,
    this.backgroundColor = Colors.brown,
    this.iconColor = Colors.white,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.add, color: iconColor, size: size * 0.5),
      ),
    );
  }
}