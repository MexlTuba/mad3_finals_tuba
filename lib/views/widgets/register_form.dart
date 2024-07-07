import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad3_finals_tuba/controllers/auth_controller.dart';
import 'package:mad3_finals_tuba/services/information_service.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/utils/waiting_dialog.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';
import 'package:mad3_finals_tuba/views/widgets/email_input_widget.dart';
import 'package:mad3_finals_tuba/views/widgets/password_input_widget.dart';
// import 'package:mobile3_finalproject_locationbasedjournal_tuba/src/controllers/auth_controller.dart';
// import 'package:mobile3_finalproject_locationbasedjournal_tuba/src/dialogs/waiting_dialog.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late GlobalKey<FormState> formKey;
  late TextEditingController username, password, password2;
  late FocusNode usernameFn, passwordFn, password2Fn;

  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    username = TextEditingController();
    usernameFn = FocusNode();
    password = TextEditingController();
    passwordFn = FocusNode();
    password2 = TextEditingController();
    password2Fn = FocusNode();
  }

  @override
  void dispose() {
    username.dispose();
    usernameFn.dispose();
    password.dispose();
    passwordFn.dispose();
    password2.dispose();
    password2Fn.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I
              .register(username.text.trim(), password.text.trim())
              .then((_) {
            Info.showSnackbarMessage(context,
                message: "Registration successful");
            context.go(Home.route);
          }).catchError((error) {
            Info.showSnackbarMessage(context,
                message: "Registration failed: $error");
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Email",
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: Color.fromRGBO(138, 150, 191, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          EmailInputWidget(
            hintText: 'Email',
            obscureText: false,
            suffixIcon: null,
            focusNode: usernameFn,
            controller: username,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Please fill out the username'),
              MaxLengthValidator(32,
                  errorText: "Username cannot exceed 32 characters"),
              EmailValidator(errorText: "Please select a valid email"),
            ]),
          ),
          SizedBox(height: 10.0),
          Text(
            "Password",
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: Color.fromRGBO(138, 150, 191, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          PasswordInputWidget(
            hintText: 'Password',
            obscureText: true,
            suffixIcon: Icons.visibility_off,
            focusNode: passwordFn,
            controller: password,
            validator: MultiValidator([
              RequiredValidator(errorText: "Password is required"),
              MinLengthValidator(12,
                  errorText: "Password must be at least 12 characters long"),
              MaxLengthValidator(128,
                  errorText: "Password cannot exceed 128 characters"),
              PatternValidator(
                  r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                  errorText:
                      'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.'),
            ]),
          ),
          SizedBox(height: 10.0),
          Text(
            "Confirm Password",
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: Color.fromRGBO(138, 150, 191, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          PasswordInputWidget(
            hintText: 'Confirm Password',
            obscureText: true,
            suffixIcon: Icons.visibility_off,
            focusNode: password2Fn,
            controller: password2,
            validator: (v) {
              String? doesMatchPasswords = password.text == password2.text
                  ? null
                  : "Passwords doesn't match";
              if (doesMatchPasswords != null) {
                return doesMatchPasswords;
              } else {
                return MultiValidator([
                  RequiredValidator(errorText: "Password is required"),
                  MinLengthValidator(12,
                      errorText:
                          "Password must be at least 12 characters long"),
                  MaxLengthValidator(128,
                      errorText: "Password cannot exceed 128 characters"),
                  PatternValidator(
                      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                      errorText:
                          'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.'),
                ]).call(v);
              }
            },
          ),
          SizedBox(height: 25.0),
          SignUpButton(text: 'Register', onPressed: onSubmit)
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  // Our primary button widget [to be reused]
  final VoidCallback onPressed;
  final String text;

  SignUpButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          color: Constants.primaryColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            this.text,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
