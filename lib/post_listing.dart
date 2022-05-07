import 'package:flutter/material.dart';

class PostListing extends StatefulWidget {
  const PostListing({Key? key}) : super(key: key);

  @override
  State<PostListing> createState() => _PostListingState();
}

class _PostListingState extends State<PostListing> {
  List<int> dropdownOptions = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 20.0, bottom: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Post a Listing",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaNegative",
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Name of Apartment Building",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Address",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 17.0),
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Rent",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 17.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Beds",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropdownButtonFormField(
                  items: dropdownOptions.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? value) {},
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Baths",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropdownButtonFormField(
                  items: dropdownOptions.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? value) {},
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Square Feet",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 17.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Contact No.",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 17.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Post",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        style: kButtonStyle,
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        style: kButtonStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var kButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(
      top: 12.0,
      bottom: 12.0,
    ),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
  ),
);
