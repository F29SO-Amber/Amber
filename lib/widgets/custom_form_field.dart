import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData icon;

  const CustomFormField({
    Key? key,
    required this.controller,
    this.validator,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 22.0),
          fillColor: Colors.amber.shade50,
          filled: true,
          hintText: 'Update your username',
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          border: border(context),
          enabledBorder: border(context),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          ),
          errorStyle: const TextStyle(height: 0.0, fontSize: 0.0),
        ),
      ),
    );
  }

  border(BuildContext context) {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.white, width: 0.0),
    );
  }
}
