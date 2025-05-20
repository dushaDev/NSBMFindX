import 'dart:async';
import 'dart:io';
import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/firebase/models/lost_item.dart';
import 'package:find_x/res/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/utils.dart';
import 'package:find_x/services/ai_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'res/compress_file.dart';
import 'firebase/auth_service.dart';
import 'firebase/fire_base_storage.dart';

class LostPost extends StatefulWidget {
  const LostPost({super.key});

  @override
  State<LostPost> createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {
  bool _useOwnNumber = true;
  bool _agreeTerms = false;
  bool _selectDate = true;
  bool _isSpinKitLoaded = false;
  double _wholePadding = 10.0;
  String _title = 'Lost Post';
  String _displayDate = "-";
  String _date = '-';
  String _displayTime = "-";
  String _lostTime = "-";
  String _amPm = '';
  String _contactNumber = '';
  List<File> _images = [];
  List<String> _imgIds = [];
  List<String> _imgUrls = ['', ''];
  int _hour24 = 0;
  int _minute = 0;
  double _uploadProgress1 = 0.0;
  double _uploadProgress2 = 0.0;
  late Future<DateTime?> _selectedDate;
  late Future<TimeOfDay?> _selectedTime;
  final FireStoreService _fireStoreService = FireStoreService();
  final FireBaseStorage _storageService = FireBaseStorage();
  final AuthService _authService = AuthService();
  final AIService _aiService = AIService();

  final TextEditingController _lostTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _contactTextController = TextEditingController();
  StreamController<String> _controller1 = StreamController<String>.broadcast();
  StreamController<String> _controller2 = StreamController<String>.broadcast();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final CompressFile _compressFile = CompressFile();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title'),
        centerTitle: true,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _wholePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText('What You Lost?', colorScheme),
                      _buildTextField(_lostTextController, 'A bag', (value) {
                        if (value == null || value.isEmpty) {
                          return 'Item required.';
                        } else if (value.length < 3) {
                          return 'Length too short.';
                        }
                        return null;
                      }, colorScheme)
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _wholePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText('Lost Time & Date', colorScheme),
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
                                style: TextStyle(color: colorScheme.onSurface),
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
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                    ),
                                    onPressed: _selectDate
                                        ? null
                                        : () {
                                            showDialogPicker(
                                                context, colorScheme);
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
                                              : colorScheme.primary,
                                        )),
                                  ),
                                  SizedBox(width: 10),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(100.0, 40.0),
                                      maximumSize: Size(200.0, 40.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                    ),
                                    onPressed: _selectDate
                                        ? null
                                        : () {
                                            showDialogTimePicker(
                                                context, colorScheme);
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
                                              : colorScheme.primary,
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
                                style: TextStyle(color: colorScheme.onSurface),
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
                      _buildText('Last Known Location', colorScheme),
                      _buildTextField(_locationTextController, 'Edge Canteen',
                          (value) {
                        if (value == null || value.isEmpty) {
                          return 'Location required.';
                        } else if (value.length < 3) {
                          return 'Length too short.';
                        }
                        return null;
                      }, colorScheme)
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
                        _buildChip('Edge Canteen', colorScheme),
                        _buildChip('Hostel Canteen', colorScheme),
                        _buildChip('Library', colorScheme),
                        _buildChip('Computing Faculty', colorScheme),
                        _buildChip('Engineering Faculty', colorScheme),
                        _buildChip('Business Faculty', colorScheme),
                      ],
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _wholePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText('Contact Number', colorScheme),
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
                                            : 'Enter Number', (value) {
                                      if (!_useOwnNumber) {
                                        if (value == null || value.isEmpty) {
                                          return 'Contact number required.';
                                        } else if (value.length != 10) {
                                          return 'Enter valid number.';
                                        }
                                      }
                                      return null;
                                    }, colorScheme,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        enabled: _useOwnNumber ? false : true);
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
                                style: TextStyle(color: colorScheme.onSurface),
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
                      _buildText('Description', colorScheme),
                      _buildTextField(_descriptionTextController,
                          'A black bag with a red stripe on the side and...',
                          (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description required.';
                        } else if (value.length < 5) {
                          return 'Length too short.';
                        }
                        return null;
                      }, colorScheme, maxLines: 3),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _wholePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText('Upload Images If You Have', colorScheme),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Upload maximum 10MB images",
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String imgId =
                                  await _pickAndUploadImage(_controller1, 1);
                              _imgIds.add(imgId);
                              _controller1.sink.add(imgId);
                              await _aiService
                                  .analyzeImageWithVision(_imgUrls[0]);
                            },
                            child: StreamBuilder(
                                stream: _controller1.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      height: 70,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                      ),
                                      child: Stack(children: [
                                        Image.file(_images[0]),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            LinearProgressIndicator(
                                              value: _uploadProgress1,
                                            ),
                                          ],
                                        )
                                      ]),
                                    );
                                  } else {
                                    return Container(
                                      height: 70,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                      ),
                                      child: Icon(Icons.add,
                                          size: 32,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(60)),
                                    );
                                  }
                                }),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              String imgId =
                                  await _pickAndUploadImage(_controller2, 2);
                              _imgIds.add(imgId);
                              _controller2.sink.add(imgId);
                              await _aiService
                                  .analyzeImageWithVision(_imgUrls[1]);
                            },
                            child: StreamBuilder(
                                stream: _controller2.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      height: 70,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                      ),
                                      child: Stack(children: [
                                        Image.file(_images[1]),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            LinearProgressIndicator(
                                              value: _uploadProgress2,
                                            ),
                                          ],
                                        )
                                      ]),
                                    );
                                  } else {
                                    return Container(
                                      height: 70,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                      ),
                                      child: Icon(Icons.add,
                                          size: 32,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(60)),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _wholePadding),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        onChanged: (value) =>
                            setState(() => _agreeTerms = value!),
                      ),
                      _buildText(
                          'Agree to our Terms and Conditions', colorScheme,
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
                                _showSnackBar(
                                    'Agree to T&C', colorScheme, true);
                              },
                        child: FilledButton(
                          onPressed: _agreeTerms
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_displayDate == '-' && !_selectDate ||
                                        _displayTime == '-' && !_selectDate) {
                                      // check if date and time are selected
                                      _showSnackBar(
                                          'Select Date Time or option \"Now\"',
                                          colorScheme,
                                          true);
                                    } else {
                                      _isSpinKitLoaded =
                                          true; // show loading spinner
                                      String? userId =
                                          await _authService.getUserId();
                                      _selectDate
                                          ? _lostTime = ReadDate().getDateNow()
                                          : _lostTime = '$_date$_displayTime';

                                      await _fireStoreService
                                          .addLostItem(LostItem(
                                              id: userId!,
                                              itemName:
                                                  _lostTextController.text,
                                              itemName_lc: _lostTextController
                                                  .text
                                                  .toLowerCase(),
                                              type: false,
                                              lostTime: _lostTime,
                                              postedTime:
                                                  ReadDate().getDateNow(),
                                              lastKnownLocation:
                                                  _locationTextController.text,
                                              contactNumber: _useOwnNumber
                                                  ? _contactNumber
                                                  : _contactTextController.text,
                                              description:
                                                  _descriptionTextController
                                                      .text,
                                              images: _imgIds,
                                              agreedToTerms: _agreeTerms,
                                              userId: userId,
                                              isCompleted: false))
                                          .whenComplete(() {
                                        _showSnackBar(
                                            'Lost item posted successfully',
                                            colorScheme,
                                            false);
                                        _isSpinKitLoaded = false;
                                        Navigator.pop(context);
                                      });
                                    }
                                  } else {
                                    _showSnackBar('Please fill all fields',
                                        colorScheme, true);
                                  }
                                }
                              : null,
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
        ],
      ),
    );
  }

  Widget _buildText(String text, ColorScheme colorScheme,
      {double bottomPadding = 10.0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: FontProfile.medium,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String hint,
      FormFieldValidator validator, ColorScheme colorScheme,
      {List<TextInputFormatter>? inputFormatters,
      int? maxLines = 1,
      bool enabled = true}) {
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
        focusedErrorBorder: OutlineInputBorder(
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

  Widget _buildChip(
    String label,
    ColorScheme colorScheme,
  ) {
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
            color: colorScheme.onSurface.withAlpha(90),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: colorScheme.outlineVariant,
            )),
      ),
    );
  }

  void showDialogPicker(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    _selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
              secondary: colorScheme.secondary,
              onPrimaryContainer: colorScheme.onPrimaryContainer,
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

  void showDialogTimePicker(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    _selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
              secondary: colorScheme.secondary,
              onPrimaryContainer: colorScheme.onPrimaryContainer,
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
        _amPm = getAmPm(value.hour);
        _minute = value.minute;
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  String getAmPm(int hour) {
    // Convert 24-hour format to AM/PM
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
    // Convert 24-hour format to 12-hour format
    if (hour24 > 12) {
      return hour24 - 12;
    }
    return hour24;
  }

  void _showSnackBar(
    // Show a SnackBar with a message and custom color for errors
    String msg,
    ColorScheme colorScheme,
    bool isError,
  ) {
    final _colorScheme = colorScheme;
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

  Future<String> _pickAndUploadImage(
      StreamController<String> controller, int progressVersion) async {
    try {
      // 1. Pick an image
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return '';

      // 2. Compress the image
      File imageFile = File(pickedFile.path);
      File compressedFile = await _compressFile.compressImage(imageFile, 700);
      _images.add(compressedFile);

      // 3. Update UI immediately with empty string (shows loading state)
      controller.sink.add('');

      // 4. Get user ID and upload
      String? userId = await _authService.getUserId();
      if (userId == null) throw Exception('User not authenticated');

      // 5. Upload with progress (using your FirebaseStorage class)
      Map<String, String> imageData = await _storageService.uploadImage(
        compressedFile,
        userId,
        (double progress) {
          // Optional: Send progress updates to stream
          if (progressVersion == 1) {
            _uploadProgress1 = progress;
          } else {
            _uploadProgress2 = progress;
          }
          controller.sink.add('');
        },
      );
      // 6. Send final URL to stream
      controller.sink.add(imageData['url']!);
      _imgUrls[progressVersion - 1] = imageData['url']!;
      return imageData['name']!;
    } catch (e) {
      // 7. Handle errors
      controller.sink.addError('Error: ${e.toString()}');
      rethrow;
    }
  }
}
