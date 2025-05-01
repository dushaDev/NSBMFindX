import 'dart:math';

import 'package:find_x/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../email_service.dart';
import '../firebase/auth_service.dart';
import '../firebase/fire_store_service.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String _title = 'Add New User';
  AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  String _autoPassword = ' dfH48k@34Fe';
  bool _isSpinKitLoaded = false;
  final _formKey = GlobalKey<FormState>();

  final List<String> _departments = [
    'Computer Science',
    'Software Engineering',
    'Data Science',
    'Cyber Security',
    'Network Engineering',
    'Web Development',
  ];
  String? _selectedDepartment;

  final List<String> _positions = [
    'Intern',
    'Junior Developer',
    'Senior Developer',
    'Team Lead',
    'Manager',
  ];
  String? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    ReadDate _readDate = ReadDate();
    FireStoreService firestoreService = FireStoreService();
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Email email = Email(
      body:
          'Logging details are here. don;t share this details. Email: ${_emailController.text} \n Password: $_autoPassword',
      subject: ' Username and Password for FindX App',
      recipients: ['dushanmadushankabeligala9@gmail.com'],
      isHTML: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          '$_title',
          style: TextStyle(color: colorScheme.primary),
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(8.0),
            //   border: Border.all(
            //       color: colorScheme.primary.withAlpha(95), width: 2.0),
            // ),
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
                            _emailController, 'user.staff.mail@email.com',
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
                        _buildText('Department', colorScheme),
                        _buildDropdown(
                            _departments,
                            "Select Department",
                            _selectedDepartment,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Department is required.';
                              }
                              return null;
                            },
                            colorScheme,
                            onChanged: (value) {
                              setState(() {
                                _selectedDepartment = value;
                              });
                            }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Position', colorScheme),
                        _buildDropdown(
                            _positions,
                            "Select Position",
                            _selectedPosition,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Position is required.';
                              }
                              return null;
                            },
                            colorScheme,
                            onChanged: (value) {
                              setState(() {
                                _selectedPosition = value;
                              });
                            }),
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

                                await authService
                                    .signUpWithEmailPassword(
                                        _emailController.text, _autoPassword)
                                    .whenComplete(() async {
                                  User? user =
                                      await authService.getSignedUser();
                                  if (user == null) {
                                    setState(() {
                                      _isSpinKitLoaded = false;
                                    });
                                    _showSnackBar(
                                        'Email already in use.Try another one',
                                        true);
                                  } else {
                                    _generatePassword();
                                    bool valid = await _sendMail(
                                        user.email!, _autoPassword);
                                    if (valid) {
                                      print('Email sent successfully');
                                    }

                                    await firestoreService
                                        .registerStaff(
                                      _idController.text,
                                      _nameController.text,
                                      _readDate.getDateNow(),
                                      _emailController.text,
                                      _contactNumberController.text,
                                      'staff',
                                      true,
                                      _selectedDepartment!,
                                      _selectedPosition!,
                                    )
                                        .whenComplete(() async {
                                      User? user =
                                          await authService.getSignedUser();
                                      await FlutterEmailSender.send(email);
                                      setState(() {
                                        _isSpinKitLoaded = false;
                                      });
                                      _showSnackBar(
                                          'User added successfully. Username and Password mailed to user',
                                          false);
                                      navigate(user);
                                    });
                                  }
                                });
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
      _showSnackBar('Something went wrong. Signup failed.', true);
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

  // Widget _buildBioField(
  //   String text,
  //   FormFieldValidator validator,
  //   ColorScheme colorScheme,
  // ) {
  //   return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: TextFormField(
  //           minLines: 3,
  //           maxLines: 5,
  //           controller: _bioController,
  //           style: TextStyle(
  //             color: colorScheme.onSurface,
  //           ),
  //           decoration: InputDecoration(
  //             enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 borderSide: BorderSide(
  //                     color: colorScheme.outlineVariant,
  //                     width: 2.0,
  //                     style: BorderStyle.solid)),
  //             focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 borderSide: BorderSide(
  //                     color: colorScheme.onSurfaceVariant,
  //                     width: 2.0,
  //                     style: BorderStyle.solid)),
  //             errorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 borderSide: BorderSide(
  //                     color: colorScheme.outlineVariant,
  //                     width: 2.0,
  //                     style: BorderStyle.solid)),
  //             focusedErrorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 borderSide: BorderSide(
  //                     color: colorScheme.outlineVariant,
  //                     width: 2.0,
  //                     style: BorderStyle.solid)),
  //             hintText: text,
  //           ),
  //           validator: validator));
  // }

  Widget _buildDropdown(
    List<String> items,
    String text,
    selectedVariable,
    FormFieldValidator validator,
    ColorScheme colorScheme, {
    required Function(dynamic) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
          value: selectedVariable,
          isExpanded: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: colorScheme.onSurfaceVariant,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
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
          ),
          hint: Text(text),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator),
    );
  }

  // Method for Generating Random Passwords
  void _generatePassword() {
    final random = Random();
    final characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    String password = '';

    for (int i = 0; i < 12; i++) {
      password += characters[random.nextInt(characters.length)];
    }
    _autoPassword = password;
  }

// Example usage when a user registers
  Future<bool> _sendMail(String email, String password) async {
    try {
      // Then send the welcome email
      await EmailService.sendRegistrationEmail(
        userEmail: email,
        password: password,
      );

      return true;
    } catch (e) {
      // Handle errors
      print('Registration failed: ${e.toString()}');
      return false;
    }
  }
}
