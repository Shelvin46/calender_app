import 'package:flutter/material.dart';

class TitleFormfield extends StatelessWidget {
  const TitleFormfield({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      style: const TextStyle(
        fontSize: 24,
      ),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Titile',
      ),
      onEditingComplete: () {},
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Title Cannot be Empty";
        } else {
          return null;
        }
      },
    );
  }
}
