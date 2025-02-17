import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LostPost extends StatefulWidget {
  const LostPost({super.key});

  @override
  State<LostPost> createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {
  String _title = 'Lost Post';
  bool _useOwnNumber = true;
  bool _agreeTerms = false;
  bool _selectDate = true;
  double _wholePadding = 10.0;
  late Future<DateTime?> selectedDate;
  String _date = "-";

  late Future<TimeOfDay?> selectedTime;
  String _time = "-";
  int _hour24 = 0;
  int _minute = 0;
  String _amPm = '';

  final TextEditingController _lostTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _contactTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _wholePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText('What You Lost?'),
                _buildTextField(_lostTextController, 'A bag')
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _wholePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText('Lost Time & Date'),
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
                              onPressed:_selectDate?null: () {
                                showDialogPicker(context);
                              },
                              child:
                                  Text(_date == '-' ? 'Select Date' : '$_date',
                                      style: TextStyle(
                                        color: _selectDate?Theme.of(context).colorScheme.onSurface.withAlpha(60):
                                        Theme.of(context)
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
                                      showDialogTimePicker(context);
                                    },
                              child: Text(
                                  _time == "-"
                                      ? "Select Time"
                                      : '${get12Hour(_hour24)}:$_minute $_amPm',
                                  style: TextStyle(
                                    color: _selectDate?Theme.of(context).colorScheme.onSurface.withAlpha(60):
                                    Theme.of(context)
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
                _buildText('Last Known Location'),
                _buildTextField(_locationTextController, 'Edge Canteen')
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
                      child: _buildTextField(
                          _contactTextController, _useOwnNumber?'076*****05':'Enter Number',
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],enabled: _useOwnNumber?false:true),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _useOwnNumber,
                          onChanged: (value) =>
                              setState(() => _useOwnNumber = value!),
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
                    maxLines: 3),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _wholePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText('Upload Images If You Have'),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Upload maximum 20MB images",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                  onTap: _agreeTerms?null:
                      (){
                    showToast('Agree to T&C');
                  },
                  child: FilledButton(
                    onPressed: _agreeTerms?() {showToast('Button Working');}:null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(150.0, 50.0),
                      maximumSize: const Size(200.0, 50.0),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildTextField(TextEditingController textController, String hint,
      {List<TextInputFormatter>? inputFormatters, int? maxLines = 1,bool enabled = true}) {
    return TextField(
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
                color: Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
                width: 2.0,
                style: BorderStyle.solid)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 2.0,
                style: BorderStyle.solid)),
        hintText: hint,
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Chip(
        deleteIcon: Icon(Icons.north_west_rounded),
        onDeleted: (){
          if(_locationTextController.text.isEmpty){
            _locationTextController.text=label;
          }else{
            _locationTextController.text='${_locationTextController.text}, $label';
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

  void showDialogPicker(BuildContext context) {
    selectedDate = showDatePicker(
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
    selectedDate.then((value) {
      setState(() {
        if (value == null) return;
        _date = Utils.getFormattedDateSimple(value.millisecondsSinceEpoch);
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void showDialogTimePicker(BuildContext context) {
    selectedTime = showTimePicker(
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
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        _time = "${value.hour} : ${value.minute}";
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
    if (hour >= 12) {
      return 'PM';
    } else {
      return 'AM';
    }
  }

  int get12Hour(int hour24) {
    if (hour24 > 12) {
      return hour24 - 12;
    }
    return hour24;
  }

  void showToast(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
