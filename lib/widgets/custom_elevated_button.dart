import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final double widthFactor;
  final VoidCallback onPress;

  const CustomElevatedButton({
    Key? key,
    required this.widthFactor,
    required this.onPress,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(buttonText),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width * widthFactor, 43),
        primary: Colors.amber.shade300,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPress,
    );
  }
}
