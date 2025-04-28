import 'package:find_x/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../firebase/fire_store_service.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  bool _isSpinKitLoaded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ReadDate _readDate = ReadDate();
    FireStoreService firestoreService = FireStoreService();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          "Add User",
          style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: FontProfile.extraLarge,
              fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: colorScheme.primary.withAlpha(95), width: 2.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Name on ID', colorScheme),
                        _buildTextFormField(_nameController, 'SDN Perera',
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required.';
                          } else if (value.length < 8) {
                            return 'Name must be at least 8 characters.';
                          }
                          return null;
                        }, colorScheme)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('ID Number', colorScheme),
                        _buildTextFormField(_idController, '24356', (value) {
                          if (value == null || value.isEmpty) {
                            return 'ID Number is required.';
                          } else if (value.length < 5) {
                            return 'ID number not valid';
                          }
                          return null;
                        }, colorScheme)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Contact Number', colorScheme),
                        _buildTextFormField(
                          _contactNumberController,
                          '0712345678',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Contact Number is required.';
                            } else if (value.length != 10) {
                              return 'Contact Number must be 10 digits.';
                            }
                            return null;
                          },
                          colorScheme,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Email', colorScheme),
                        _buildTextFormField(
                            _emailController, 'your.student.maail@email.com',
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required.';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email format.';
                          }
                          return null;
                        }, colorScheme)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Password', colorScheme),
                        _buildTextFormField(
                          _passwordController,
                          '********',
                          (value) {
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
                          colorScheme,
                          obscureText: true,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Repeat password', colorScheme),
                        _buildTextFormField(
                            _repeatPasswordController, '********', (value) {
                          if (value == null || value.isEmpty) {
                            return 'Repeat Password is required.';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        }, obscureText: true, colorScheme),
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
                                      fontSize: FontProfile.extraSmall,
                                    ),
                                    "Password must contain minimum 8 characters with numbers,a special character and one uppercase letter"),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildText('Bio', colorScheme),
                            _buildBioField('Enter your bio', (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bio is required.';
                              }
                              return null;
                            }, colorScheme),
                          ],
                        ),
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
                                try {
                                  await firestoreService.registerStudent(
                                    _idController.text,
                                    _nameController.text,
                                    _readDate.getDateNow(),
                                    _emailController.text,
                                    _contactNumberController.text,
                                    'student',
                                    _bioController.text,
                                    'additionalArgument1', // Replace with actual value,should remove this
                                    'additionalArgument2', // Replace with actual value,should remove this
                                  );
                                  setState(() {
                                    _isSpinKitLoaded = false;
                                  });
                                  _showSnackBar(
                                      'User added successfully!', false);
                                } catch (e) {
                                  setState(() {
                                    _isSpinKitLoaded = false;
                                  });
                                  _showSnackBar('Failed to add user: $e', true);
                                }
                              } else {
                                _showSnackBar('Form validation failed.', true);
                              }
                            },
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(150.0, 50.0),
                              maximumSize: const Size(200.0, 50.0),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              textStyle: const TextStyle(
                                fontSize: FontProfile.medium,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              padding: const EdgeInsets.only(
                                  left: 50.0,
                                  right: 50.0,
                                  top: 15.0,
                                  bottom: 15.0),
                            ),
                            child: const Text("Add User"),
                          )
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
                child: SpinKitThreeBounce(
                  color: colorScheme.primary,
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
      _showSnackBar('Something went wrong. Signup failed.',true);
    }
  }

  void _showSnackBar(String msg, bool isError) {
    final _colorScheme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Text(msg,
          style: TextStyle(
            color: _colorScheme.onSecondary,
          )),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? _colorScheme.secondary : _colorScheme.primary,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildText(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 6.0,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: FontProfile.medium,
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController textController, String hint,
      FormFieldValidator validator, ColorScheme colorScheme,
      {obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: textController,
      style: TextStyle(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: colorScheme.outline,
                width: 2.0,
                style: BorderStyle.solid)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: colorScheme.outlineVariant,
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

  Widget _buildBioField(
    String text,
    FormFieldValidator validator,
    ColorScheme colorScheme,
  ) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            minLines: 3,
            maxLines: 5,
            controller: _bioController,
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 2.0,
                      style: BorderStyle.solid)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: colorScheme.onSurfaceVariant,
                      width: 2.0,
                      style: BorderStyle.solid)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 2.0,
                      style: BorderStyle.solid)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 2.0,
                      style: BorderStyle.solid)),
              hintText: text,
            ),
            validator: validator));
  }
}