import 'package:flutter/material.dart';

Widget buildField(String hint, {bool obscure = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required field";
        }
        return null;
      },
      decoration: _inputDecoration(hint),
    ),
  );
}

Widget sectionTitle(String title) {
  return Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
      Expanded(child: Divider()),
    ],
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
