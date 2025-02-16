
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'firebase/auth_service.dart';
import 'firebase/fire_store_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  bool _isSpinKitLoaded = false;
  final _formKey = GlobalKey<FormState>();

  _SignupState();
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    FireStoreService firestoreService = FireStoreService();
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 36.0,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 6.0, left: 8.0, right: 8.0),
                        child: Text(
                          "Name",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            hintText: "Sanath Perera",
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required.';
                            } else if (value.length < 10) {
                              return 'Name must be at least 10 characters.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 6.0, left: 8.0, right: 8.0),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            hintText: "sanathp99@email.com",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required.';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Invalid email format.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 6.0, left: 8.0, right: 8.0),
                        child: Text(
                          "Create a password",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            hintText: "********",
                          ),
                          obscureText: true,
                          obscuringCharacter: "*",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required.';
                            }
                            final passwordRegex = RegExp(
                                r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$');
                            if (!passwordRegex.hasMatch(value)) {
                              return 'Password must be at least 8 characters long, '
                                  'contain an uppercase letter, a number, and a special character.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 6.0, left: 8.0, right: 8.0),
                        child: Text(
                          "Repeat password",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _repeatPasswordController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            hintText: "********",
                          ),
                          obscureText: true,
                          obscuringCharacter: "*",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Repeat Password is required.';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            Flexible(
                              child: Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 13.0),
                                  "password must contain minimum 8 characters with numbers,a special character and one uppercase letter"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isSpinKitLoaded = true;
                              });
                              await authService.signUpWithEmailPassword(
                                  _emailController.text,
                                  _passwordController.text).whenComplete(() async {
                                User? user = await authService.getSignedUser();
                                if(user==null){
                                  setState(() {
                                    _isSpinKitLoaded = false;
                                  });
                                  showToast('Email already in use.Try another one');
                                }else{
                                  await firestoreService
                                      .register(_emailController.text,
                                      _nameController.text)
                                      .whenComplete(() async {
                                    User? user = await authService.getSignedUser();
                                    setState(() {
                                      _isSpinKitLoaded = false;
                                    });
                                    authService.signOut().whenComplete((){
                                      showToast('Registration successfully. use Login');
                                      navigate(user);
                                    });

                                  });
                                }
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
                            textStyle: const TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.only(
                                left: 50.0,
                                right: 50.0,
                                top: 15.0,
                                bottom: 15.0),
                          ),
                          child: const Text("Sign up"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _isSpinKitLoaded
            ? Align(
                alignment: Alignment.bottomCenter,
                child: SpinKitThreeBounce(
                  color: Theme.of(context).colorScheme.primary,
                  size: 25.0,
                ),
              )
            : Container(),
      ]),
    );
  }

  void navigate(User? user) {
    if (user != null) {
      Navigator.of(context).pop();
    } else {
      showToast('Something went wrong. Signup failed.');
    }
  }

  void showToast(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
