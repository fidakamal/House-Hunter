import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/profile/user_listing_card.dart';
import 'package:house_hunter/components/rounded_button.dart';
import 'package:house_hunter/post_listing/post_listing.dart';

class LoggedInProfile extends StatelessWidget {
  const LoggedInProfile(
      {Key? key, required this.logout, required this.userEmail})
      : super(key: key);
  final Function logout;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.maps_home_work_outlined, size: 35.0),
                SizedBox(width: 7.0),
                Text(
                  "My Properties",
                  style:
                      TextStyle(fontSize: 30.0, fontFamily: "SignikaNegative"),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("rentals")
                  .where("user", isEqualTo: userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final rentals = snapshot.data!.docs;
                if (rentals.isEmpty) return SizedBox(height: 220.0);
                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: rentals
                      .map((rental) => UserListingCard(doc: rental))
                      .toList(),
                );
              },
            ),
            SizedBox(height: 10.0),
            RoundedButton(
              title: "Post a listing",
              color: Colors.cyanAccent.shade700,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostListing()),
                );
              },
            ),
            RoundedButton(
              title: "Log out",
              color: Colors.red.shade300,
              onPressed: () => logout(),
            ),
          ],
        ),
      ),
    );
  }
}
