import 'package:find_x/firebase/auth_service.dart';
import 'package:find_x/firebase/models/found_item.dart';
import 'package:find_x/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase/fire_store_service.dart';

class FoundPost extends StatefulWidget {
  const FoundPost({super.key});

  @override
  State<FoundPost> createState() => _FoundPostState();
}

class _FoundPostState extends State<FoundPost> {
  String _title = 'Found Post';
  bool _useOwnNumber = true;
  bool _agreeTerms = false;
  bool _selectDate = true; // to select date or now in Radio button (true = now)
  double _wholePadding = 10.0; // to set padding for all widgets
  late Future<DateTime?> _selectedDate;
  late Future<TimeOfDay?> _selectedTime;
  String _displayDate = "-"; //to store the selected date
  String _date = '-';
  String _displayTime = "-"; //to store the selected date
  String _lostTime = "-";
  String _amPm = ''; //to store AM/PM
  int _hour24 = 0; //to store the selected hour in 24 hours format
  int _minute = 0;
  String _contactNumber = '';

  String? _selectedPrivacy = 'Public';
  String? _selectedFaculty;
  String? _selectedDegree;
  final List<String> _privacy_list = ['Public', 'Restricted', 'Private'];
  final List<String> _faculties = [
    'Faculty of Computing',
    'Faculty of Business',
    'Faculty of Engineering'
  ];
  final List<String> _degrees = [
    'Computer Science',
    'Software Engineering',
    'Computer Networks',
    'Management Information Systems',
    'Data Science',
    'Business Administration',
    'Civil Engineering'
  ];

  FireStoreService _fireStoreService = FireStoreService();
  AuthService _authService = AuthService();
  final TextEditingController _foundTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _contactTextController = TextEditingController();
  final TextEditingController _idTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText('Upload Images'),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Upload maximum 20MB images",
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        child: Icon(Icons.add,
                            size: 32,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(60)),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        child: Icon(Icons.add,
                            size: 32,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(60)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText('What You Found?'),
                    _buildTextField(_foundTextController, 'A bag', (value) {
                      if (value == null || value.isEmpty) {
                        return 'Item required.';
                      } else if (value.length < 3) {
                        return 'Minimum 3 characters required.';
                      }
                      return null;
                    }),
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText('Privacy'),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outlineVariant,
                                width: 2.0,
                                style: BorderStyle.solid)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color:
                                Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
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
                        focusedErrorBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 2.0,
                                style: BorderStyle.solid)),
                      ),
                      value: _selectedPrivacy, // Currently selected value
                      hint: Text('Select'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPrivacy = newValue;
                        });
                      },
                      items: _privacy_list
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface)),
                        );
                      }).toList(),
                      isExpanded: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Privacy required.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            _selectedPrivacy == 'Private'
                ? Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: _wholePadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildText('ID No'),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: _buildTextField(
                                _idTextController,
                                '26334',
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ID no required.';
                                  } else if (value.length != 5) {
                                    return 'Enter valid id.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            _selectedPrivacy == 'Restricted'
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: _wholePadding),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildText('Faculty'),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.outlineVariant,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color:
                                          Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
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
                                  focusedErrorBorder:  OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.outline,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                ),
                                value: _selectedFaculty,
                                hint: Text('Select'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedFaculty = newValue;
                                  });
                                },
                                items: _faculties
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface)),
                                  );
                                }).toList(),
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Faculty required.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildText('Degree'),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.outlineVariant,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color:
                                          Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
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
                                  focusedErrorBorder:  OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.outline,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                ),
                                value:
                                    _selectedDegree, // Currently selected value
                                hint: Text(
                                    'Select'), // Hint text when no value is selected
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDegree =
                                        newValue; // Update the selected value
                                  });
                                },
                                items: _degrees
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface)),
                                  );
                                }).toList(),
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Degree required.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText('Found Time & Date'),
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: false,
                            groupValue: _selectDate,
                            onChanged: (value) =>
                                setState(() => _selectDate = false),
                          ),
                          Text(
                            "Select Date & Time",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(100.0, 40.0),
                                  maximumSize: Size(200.0, 40.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                ),
                                onPressed: _selectDate
                                    ? null
                                    : () {
                                        _showDialogPicker(context);
                                      },
                                child: Text(
                                    _displayDate == '-'
                                        ? 'Select Date'
                                        : '$_displayDate',
                                    style: TextStyle(
                                      color: _selectDate
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(60)
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    )),
                              ),
                              SizedBox(width: 10),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(100.0, 40.0),
                                  maximumSize: Size(200.0, 40.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                ),
                                onPressed: _selectDate
                                    ? null
                                    : () {
                                        _showDialogTimePicker(context);
                                      },
                                child: Text(
                                    _displayTime == "-"
                                        ? "Select Time"
                                        : '${get12Hour(_hour24)}:$_minute $_amPm',
                                    style: TextStyle(
                                      color: _selectDate
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(60)
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: _selectDate,
                            onChanged: (value) =>
                                setState(() => _selectDate = true),
                          ),
                          Text(
                            "Now",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText('Where Now Item?'),
                  _buildTextField(
                    _locationTextController,
                    'Edge Canteen',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'required.';
                      } else if (value.length < 2) {
                        return 'Minimum 2 characters required.';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
                height: 40, // Hei

                child: ListView(
                  padding: EdgeInsets.only(left: 20.0),
                  scrollDirection: Axis.horizontal, // Horizontal scroll
                  children: [
                    _buildChip('Edge Canteen'),
                    _buildChip('Hostel Canteen'),
                    _buildChip('Library'),
                    _buildChip('Computing Faculty'),
                    _buildChip('Engineering Faculty'),
                    _buildChip('Business Faculty'),
                  ],
                )),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText('Contact Number'),
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder(
                            future: _authService.getUserContact(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.hasData) {
                                _contactNumber = snapshot.data!;
                                return _buildTextField(
                                  _contactTextController,
                                  _useOwnNumber
                                      ? _setAsterisk(_contactNumber)
                                      : 'Enter Number',
                                  (value) {
                                    if (!_useOwnNumber) {
                                      if (value == null || value.isEmpty) {
                                        return 'Contact Number required.';
                                      } else if (value.length != 10) {
                                        return 'Enter valid number.';
                                      }
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  enabled: _useOwnNumber ? false : true,
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _useOwnNumber,
                            onChanged: (value) => setState(() {
                              _useOwnNumber = value!;
                              _contactTextController.clear();
                            }),
                          ),
                          Text(
                            "Use Own",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText('Description'),
                  _buildTextField(_descriptionTextController,
                      'A black bag with a red stripe on the side and...',
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description required.';
                    } else if (value.length < 5) {
                      return 'Minimum 5 characters required.';
                    }
                    return null;
                  }, maxLines: 3),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _wholePadding),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    onChanged: (value) => setState(() => _agreeTerms = value!),
                  ),
                  _buildText('Agree to our Terms and Conditions',
                      bottomPadding: 0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _agreeTerms
                        ? null
                        : () {
                            _showSnackBar('Agree to T&C', true);
                          },
                    child: FilledButton(
                      onPressed: _agreeTerms
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                //check if all fields are valid
                                if (_displayDate == '-' && !_selectDate ||
                                    _displayTime == '-' && !_selectDate) {
                                  // check if date and time are selected
                                  _showSnackBar(
                                      'Select Date Time or Now', true);
                                } else {
                                  String? userId =
                                      await _authService.getUserId();
                                  _selectDate
                                      ? _lostTime = ReadDate().getDateNow()
                                      : _lostTime = '$_date$_displayTime';

                                  await _fireStoreService.addFoundItem(
                                      FoundItem(
                                          id: userId!,
                                          itemName: _foundTextController.text,
                                          type: true,
                                          foundTime: _lostTime,
                                          postedTime: ReadDate().getDateNow(),
                                          contactNumber: _useOwnNumber
                                              ? _contactNumber
                                              : _contactTextController.text,
                                          description:
                                              _descriptionTextController.text,
                                          currentLocation:
                                              _locationTextController.text,
                                          images: [
                                            'path/to/image1.jpg',
                                            'path/to/image2.jpg'
                                          ],
                                          agreedToTerms: _agreeTerms,
                                          userId: userId,
                                          privacy: _selectedPrivacy!,
                                          restrictedFacultyId: _selectedPrivacy ==
                                                  'Restricted'
                                              ? _selectedFaculty
                                              : null, // when send selected faculty, after 'Restricted' selected,
                                          restrictedDegreeProgramId:
                                              _selectedPrivacy == 'Restricted'
                                                  ? _selectedDegree
                                                  : null,
                                          privateUserId:
                                              _selectedPrivacy == 'Private'
                                                  ? _idTextController.text
                                                  : null,
                                          isCompleted: false));
                                }
                              } else {
                                _showSnackBar('Please fill all fields', true);
                              }
                            }
                          : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(150.0, 50.0),
                        maximumSize: const Size(200.0, 50.0),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        textStyle: const TextStyle(
                          fontSize: FontProfile.medium,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.only(
                            left: 50.0, right: 50.0, top: 15.0, bottom: 15.0),
                      ),
                      child: const Text("Post Now"),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, {double bottomPadding = 10.0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: FontProfile.medium,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController textController,
    String hint,
    FormFieldValidator validator, {
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      enabled: enabled,
      maxLines: maxLines,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      inputFormatters: inputFormatters,
      controller: textController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2.0,
                style: BorderStyle.solid)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
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
        focusedErrorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 2.0,
                style: BorderStyle.solid)),
        hintText: hint,
      ),
      validator: validator,
    );
  }

  Widget _buildChip(String label) {
    //to create chips for location/ Where now Item?
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Chip(
        deleteIcon: Icon(Icons.north_west_rounded),
        onDeleted: () {
          if (_locationTextController.text.isEmpty) {
            _locationTextController.text = label;
          } else {
            _locationTextController.text =
                '${_locationTextController.text}, $label';
          }
        },
        label: Text(
          label,
          style: TextStyle(
            fontSize: FontProfile.extraSmall,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            )),
      ),
    );
  }

  void _showDialogPicker(BuildContext context) {
    //for date picker to select date
    _selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
              secondary: Theme.of(context).colorScheme.secondary,
              onPrimaryContainer:
                  Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          child: child!,
        );
      },
    );
    _selectedDate.then((value) {
      setState(() {
        if (value == null) return;
        _displayDate = Utils.getFormattedDateSimple(
            value.millisecondsSinceEpoch,
            dateFormat: "MMMM dd, yyyy");
        _date = Utils.getFormattedDateSimple(value.millisecondsSinceEpoch);
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void _showDialogTimePicker(BuildContext context) {
    _selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
              secondary: Theme.of(context).colorScheme.secondary,
              onPrimaryContainer:
                  Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          child: child!,
        );
      },
    );
    _selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        _displayTime = "/${value.hour}/${value.minute}";
        _hour24 = value.hour;
        _amPm = _getAmPm(value.hour);
        _minute = value.minute;
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  String _getAmPm(int hour) {
    //convert 24 hour to am/pm
    if (hour >= 12) {
      return 'PM';
    } else {
      return 'AM';
    }
  }

  // function to set * to center 3 characters
  String _setAsterisk(String str) {
    if (str.length > 3) {
      return str.substring(0, 3) +
          '*' * (str.length - 7) +
          str.substring(str.length - 4, str.length);
    }
    return str;
  }

  int get12Hour(int hour24) {
    //convert 24 hour to 12 hour
    if (hour24 > 12) {
      return hour24 - 12;
    }
    return hour24;
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
  } //snackBar customized with colors when error or not
}
