// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';

class EmailInputWidget extends StatefulWidget {
  final String hintText;
  final IconData? suffixIcon;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  EmailInputWidget({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    required this.obscureText,
    this.focusNode,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _EmailInputWidgetState createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Constants.primaryColor,
      obscureText: widget.obscureText,
      focusNode: widget.focusNode,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: Color.fromRGBO(124, 124, 124, 1),
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: widget.suffixIcon != null
            ? Icon(
                widget.suffixIcon,
                color: Color.fromRGBO(105, 108, 121, 1),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Color.fromRGBO(
                200, 200, 200, 0.5), // Light grey with some transparency
            width: 1.0, // Border thickness
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Constants.primaryColor,
            width: 1.0, // Thicker border when the field is focused
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
