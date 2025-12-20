// import 'package:flutter/material.dart';

// class TaggedRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final VoidCallback? onTap;
//   final bool showDownArrow;

//   const TaggedRow({
//     super.key,
//     required this.icon,
//     required this.text,
//     this.onTap,
//     this.showDownArrow = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon),
//                 SizedBox(width: 6),
//                 Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
//               ],
//             ),
//             if (showDownArrow) Icon(Icons.arrow_drop_down, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TaggedRow extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool showDownArrow;
  final List<Widget>? children;

  const TaggedRow({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.showDownArrow = true,
    this.children,
  });

  @override
  State<TaggedRow> createState() => _TaggedRowState();
}

class _TaggedRowState extends State<TaggedRow>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
            if (widget.onTap != null) widget.onTap!();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon),
                    SizedBox(width: 6),
                    Text(
                      widget.text,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                if (widget.showDownArrow)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0, 
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Icon(Icons.arrow_drop_down, size: 24),
                  ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ConstrainedBox(
            constraints: isExpanded
                ? BoxConstraints()
                : BoxConstraints(maxHeight: 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children ?? [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


