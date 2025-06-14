import 'package:flutter/material.dart';

class ExpenseTextField extends StatelessWidget {
  final String hint;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const ExpenseTextField({super.key, 
    required this.hint,
    this.inputType = TextInputType.text,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: inputType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
