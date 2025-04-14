import 'package:find_x/index_page.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'firebase/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSpinKitLoaded = false;
  final _formKey = GlobalKey<FormState>();

  _LoginState();
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(95),
                  width: 2,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //_buildHeadline('Login'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Email'),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _buildTextFormField(
                              _emailController,
                              'yourmail@email.com',
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required.';
                                }
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Invalid email format.';
                                }
                                return null;
                              },
                            ))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Password'),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _buildTextFormField(
                              _passwordController,
                              '********',
                              obscureText: true,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required.';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long.';
                                }
                                return null;
                              },
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 70.0),
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            setState(() {
                              _isSpinKitLoaded = true;
                            });

                            authService
                                .signInWithEmailPassword(_emailController.text,
                                    _passwordController.text)
                                .whenComplete(() async {
                              User? user = await authService.getSignedUser();
                              setState(() {
                                _isSpinKitLoaded = false;
                              });
                              navigate(user);
                            });
                          }
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(150.0, 50.0),
                          maximumSize: const Size(200.0, 50.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          textStyle: TextStyle(fontSize: FontProfile.medium),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50.0, top: 15.0, bottom: 15.0),
                        ),
                        child: const Text("Log in"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                          onTap: () {
                            _showSnackBar(
                                'Coming soon, Please contact the administrator');
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: FontProfile.small,
                                fontWeight: FontWeight.normal),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: FontProfile.small,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Signup()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: FontProfile.small,
                                    fontWeight: FontWeight.w800),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _isSpinKitLoaded
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  child: SpinKitThreeBounce(
                    color: Theme.of(context).colorScheme.primary,
                    size: 25.0,
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }

  Widget _buildTextFormField(TextEditingController textController, String hint,
      FormFieldValidator validator,
      {obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: textController,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 2.0,
                style: BorderStyle.solid)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid)),
        hintText: hint,
      ),
      obscureText: obscureText,
      obscuringCharacter: "*",
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 6.0,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: FontProfile.medium,
        ),
      ),
    );
  }

  void navigate(User? user) {
    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => IndexPage()),
        (Route<dynamic> route) => false, // Remove all routes
      );
    } else {
      _showSnackBar('Login failed. Email or password is wrong.');
    }
  }

  void _showSnackBar(String msg) {
    final _colorScheme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Text(msg,
          style: TextStyle(
            color: _colorScheme.onSecondary,
          )
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: _colorScheme.secondary,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
