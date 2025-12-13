import 'package:flutter/material.dart';
import 'package:slack_clone/core/constants/app_colors.dart';

class TextWithButton extends StatelessWidget {
  const TextWithButton({
    super.key,
    required this.text,
    required this.buttonText,
    this.onPressed,
  this.tfontSize,
  this.t2fontSize
  });
  final String text;
  final String buttonText;
  final VoidCallback? onPressed;
   final double? tfontSize;
   final double? t2fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style:  TextStyle(
              fontSize: t2fontSize??14,
            color: AppColors.blackTextColor,
            fontFamily: 'SignikaNegative',
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.blue,
              fontSize: tfontSize??14,
              fontFamily: 'SignikaNegative',
            ),
          ),
        ),
      ],
    );
  }
}
