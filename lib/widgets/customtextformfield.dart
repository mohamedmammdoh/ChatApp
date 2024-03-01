import 'package:flutter/material.dart';

class customtextformfield extends StatelessWidget {
  customtextformfield({
    super.key,
    this.hint_text,
    this.label_text,
    this.onchanged,
    this.validator,
    this.obsuretext = false,
  });
  final String? hint_text;

  final String? label_text;
  Function(String)? onchanged;
  String? Function(String?)? validator;
  bool? obsuretext;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsuretext!,
      validator: validator,
      onChanged: onchanged,
      controller: TextEditingController(),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        hintText: hint_text,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        label: Text('$label_text'),
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
