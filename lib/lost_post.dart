import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LostPost extends StatefulWidget {
  const LostPost({super.key});

  @override
  State<LostPost> createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {
  String _title = 'Lost Post';
  bool useOwnNumber = false;
  bool agreeTerms = false;
  bool selectDate = true;
  double _wholePadding = 10.0;

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
                          value: true,
                          groupValue: selectDate,
                          onChanged: (value) =>
                              setState(() => selectDate = true),
                        ),
                        Text(
                          "Select Date",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                          onPressed: () {},
                          child: Text("Jun 10, 2024",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ),
                        SizedBox(width: 10),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                          onPressed: () {},
                          child: Text("9:41 AM",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: selectDate,
                          onChanged: (value) =>
                              setState(() => selectDate = false),
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
                          _contactTextController, '07*******5',
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: useOwnNumber,
                          onChanged: (value) =>
                              setState(() => useOwnNumber = value!),
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
                  value: agreeTerms,
                  onChanged: (value) => setState(() => agreeTerms = value!),
                ),
                _buildText('Agree to our Terms and Conditions',
                    bottomPadding: 0),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Post Now",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary)),
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
            color: Theme.of(context).colorScheme.onSurface, fontSize: 18.0),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String hint,
      {List<TextInputFormatter>? inputFormatters, int? maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      controller: textController,
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
        hintText: hint,
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(fontSize: 12.0),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            )),
      ),
    );
  }
}
