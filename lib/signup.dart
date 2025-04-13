import 'package:find_x/login.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  final List<String> _faculties = [
    'Faculty of Computing',
    'Faculty of Business',
    'Faculty of Engineering'
  ];
  String? _selectedFaculty;
  final List<String> _degrees = [
    'BSc(Hons) in Computer Science',
    'BSc(Hons) in Software Engineering',
    'BSc(Hons) in Computer Networks',
    'BSc(Hons) in Management Information Systems',
    'BSc(Hons) in Data Science',
    'BBA(Hons) in Business Administration',
    'BEng(Hons) in Civil Engineering'
  ];
  String? _selectedDegree;
  bool _isSpinKitLoaded = false;
  final _formKey = GlobalKey<FormState>();

  // _SignupState();
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    FireStoreService firestoreService = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Sign Up",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
                  color: Theme.of(context).colorScheme.primary.withAlpha(95),
                  width: 2.0),
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
                        _buildText('Name on ID'),
                        _buildTextFormField(_nameController, 'SDN Perera',
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required.';
                          } else if (value.length < 8) {
                            return 'Name must be at least 8 characters.';
                          }
                          return '';
                        })
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('ID Number'),
                        _buildTextFormField(_idController, '24356', (value) {
                          if (value == null || value.isEmpty) {
                            return 'ID Number is required.';
                          }
                          return '';
                        })
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Faculty'),
                        _buildDropdown(
                            _faculties, 'Select Faculty', _selectedFaculty,
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Faculty is required.';
                          }
                          return '';
                        }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Degree Program'),
                        _buildDropdown(
                            _degrees, "Select Degree", _selectedDegree,
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Degree is required.';
                          }
                          return '';
                        }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Contact Number'),
                        _buildTextFormField(
                          _contactNumberController,
                          '0712345678',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Contact Number is required.';
                            } else if (value.length != 10) {
                              return 'Contact Number must be 10 digits.';
                            }
                            return '';
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Email'),
                        _buildTextFormField(
                            _emailController, 'samplemaail@email.com', (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required.';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email format.';
                          }
                          return '';
                        })
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Password'),
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
                            return '';
                          },
                          obscureText: true,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Repeat password'),
                        _buildTextFormField(
                          _repeatPasswordController,
                          '********',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Repeat Password is required.';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return '';
                          },
                          obscureText: true,
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
                                      fontSize: FontProfile.extraSmall,
                                    ),
                                    "password must contain minimum 8 characters with numbers,a special character and one uppercase letter"),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildText('Bio'),
                            _buildBioField('Enter your bio', (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bio is required.';
                              }
                              return '';
                            }),
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
                                await authService
                                    .signUpWithEmailPassword(
                                        _emailController.text,
                                        _passwordController.text)
                                    .whenComplete(() async {
                                  User? user =
                                      await authService.getSignedUser();
                                  if (user == null) {
                                    setState(() {
                                      _isSpinKitLoaded = false;
                                    });
                                    showToast(
                                        'Email already in use.Try another one');
                                  } else {
                                    await firestoreService
                                        .registerStudent(
                                            '28232',
                                            _nameController.text,
                                            _emailController.text,
                                            'student',
                                            'f1',
                                            'd1',
                                            'about here')
                                        .whenComplete(() async {
                                      User? user =
                                          await authService.getSignedUser();
                                      setState(() {
                                        _isSpinKitLoaded = false;
                                      });
                                      authService.signOut().whenComplete(() {
                                        showToast(
                                            'Registration successfully. use Login');
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
                            child: const Text("Sign up"),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
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
                                        builder: (context) => const Login()));
                              },
                              child: Text(
                                "Sign in",
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

  Widget _buildDropdown(
    List<String> items,
    String text,
    selectedVariable,
    FormFieldValidator validator,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
          value: selectedVariable,
          isExpanded: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
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
          ),
          hint: Text(text),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedVariable = newValue;
            });
          },
          validator: validator),
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

  Widget _buildBioField(String text, FormFieldValidator validator) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            minLines: 3,
            maxLines: 5,
            controller: _bioController,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              hintText: text,
            ),
            validator: validator));
  }
}
