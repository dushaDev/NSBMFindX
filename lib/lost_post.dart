import 'package:flutter/material.dart';

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

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            Text("What You Lost?",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
            TextField(
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
                hintText: "A bag",
              ),
            ),
            SizedBox(height: 20),
            Text("Lost Time & Date",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: selectDate,
                  onChanged: (value) => setState(() => selectDate = true),
                ),
                Text("Select Date",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onPressed: () {},
                  child: Text("Jun 10, 2024", style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer,)),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onPressed: () {},
                  child: Text("9:41 AM", style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer,)),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: selectDate,
                  onChanged: (value) => setState(() => selectDate = false),
                ),
                Text("Now",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              ],
            ),
            SizedBox(height: 20),
            Text("Last Known Location",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
            TextField(
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
                hintText: "Edge Canteen",
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40, // Height of the suggestion row
              child: ListView(
                padding: EdgeInsets.only(left: 20.0),
                scrollDirection: Axis.horizontal, // Horizontal scroll
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      label: Text("Edge Canteen"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      label: Text("Hostel Canteen"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      label: Text("Library"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Chip(
                      label: Text("Computing Faculty"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Contact Number",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
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
                      hintText: "07******05",
                    ),
                  ),
                ),
                Checkbox(
                  value: useOwnNumber,
                  onChanged: (value) => setState(() => useOwnNumber = value!),
                ),
                Text("Use Own",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              ],
            ),
            SizedBox(height: 20),
            Text("Description",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
            TextField(
              maxLines: 3,
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
                hintText: "A black bag with a red stripe on the side and...",
              ),
            ),
            SizedBox(height: 20),
            Text("Upload Images If You Have"),
            Text("Upload maximum 20MB images", style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, size: 40, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, size: 40, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: agreeTerms,
                  onChanged: (value) => setState(() => agreeTerms = value!),
                ),
                Text("Agree to our Terms and Conditions"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Post Now",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
