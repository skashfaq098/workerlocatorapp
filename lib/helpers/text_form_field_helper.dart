import 'package:flutter/material.dart';

class TextFormFieldHelper extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function validator;
  final TextInputType textInputType;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final Function suffixonPressed;
  final Function onSaved;
  final bool obscureText;
  final Function onChanged;
  const TextFormFieldHelper(
      {Key key,
      this.controller,
      this.labelText,
      this.hintText,
      this.validator,
      this.textInputType,
      this.prefixIconData,
      this.suffixIconData,
      this.suffixonPressed,
      this.obscureText,
      this.onSaved,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800]),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          onSaved: onSaved,
          style: TextStyle(fontSize: 18),
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          decoration: new InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIconData, color: Colors.green),
            suffixIcon: IconButton(
              icon: Icon(suffixIconData, color: Colors.grey),
              onPressed: suffixonPressed,
            ),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            fillColor: Colors.grey[100],
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: const Color(0xffF5F0F7), width: 0.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1.0, color: Colors.red)),
          ),
        ),
      ],
    );
  }
}
