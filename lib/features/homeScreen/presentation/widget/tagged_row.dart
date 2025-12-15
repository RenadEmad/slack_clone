import 'package:flutter/material.dart';

class TaggedRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool showDownArrow;

  const TaggedRow({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.showDownArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 6),
                Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            if (showDownArrow) Icon(Icons.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }
}