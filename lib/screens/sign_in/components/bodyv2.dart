import 'package:flutter/material.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../login_success/login_success_screen.dart';

class BodyV2 extends StatefulWidget {
  const BodyV2({Key? key}) : super(key: key);

  @override
  _BodyV2State createState() => _BodyV2State();
}

class _BodyV2State extends State<BodyV2> {
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Grob',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person, color: kPrimaryColor),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                    ),
                    // controller: _passwordController,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                    ),
                    // controller: _passwordController,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  DefaultButton(
                    text: "Sign In",
                    press: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // if all are valid then go to success screen
                        KeyboardUtil.hideKeyboard(context);
                        Navigator.pushReplacementNamed(
                            context, LoginSuccessScreen.routeName);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
