import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String buttonText;
  final double widthFactor;
  final VoidCallback onPress;

  const CustomOutlinedButton({
    Key? key,
    required this.widthFactor,
    required this.onPress,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(buttonText),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.amber.shade50,
        fixedSize: Size(MediaQuery.of(context).size.width * widthFactor, 40),
        primary: Colors.black,
        side: BorderSide(width: 1.0, color: Colors.amber.shade500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPress,
    );
  }
}
