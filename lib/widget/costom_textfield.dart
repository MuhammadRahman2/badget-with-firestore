import 'package:flutter/material.dart';

class CostomTextField extends StatelessWidget {
  final String? title;
  final TextEditingController? controllers;
  const CostomTextField({super.key, this.title, this.controllers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: TextFormField(
        controller: controllers,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Title form is empty';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
