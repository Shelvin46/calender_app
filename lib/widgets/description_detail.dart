import 'package:flutter/material.dart';

class DescriptionFormField extends StatelessWidget {
  final TextEditingController descriptionController;

  const DescriptionFormField({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: descriptionController,
        decoration: const  InputDecoration(
          hintText: 'Description',
          border: OutlineInputBorder(),
        ),
        maxLines: null,
      ),
    );
  }
}
