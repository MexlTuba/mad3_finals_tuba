// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';

class PasswordInputWidget extends StatefulWidget {
  final String hintText;
  final IconData? suffixIcon;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  PasswordInputWidget({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    required this.obscureText,
    this.focusNode,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _PasswordInputWidgetState createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Constants.primaryColor,
      obscureText: _isPasswordVisible,
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
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color.fromRGBO(105, 108, 121, 1),
                ),
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
