import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final double height;
  SearchInputWidget(
      {required this.hintText, required this.prefixIcon, this.height = 53.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.only(
        right: 16.0,
        left: this.prefixIcon == null ? 16.0 : 0.0,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: this.prefixIcon == null
              ? null
              : Icon(
                  this.prefixIcon,
                  color: Color.fromRGBO(105, 108, 121, 1),
                ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: this.hintText,
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(105, 108, 121, 1),
          ),
        ),
      ),
    );
  }
}
