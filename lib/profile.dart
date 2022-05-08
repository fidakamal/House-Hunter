import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/register.dart';
import 'package:house_hunter/components/rounded_button.dart';
import 'package:house_hunter/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house_hunter/post_listing/post_listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
String userEmail = "no user";

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User loggedInUser;

  void setUser(String email) {
    setState(() {
      userEmail = email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (_auth.currentUser != null) {
      loggedInUser = _auth.currentUser!;
      userEmail = loggedInUser.email!;
    }
  }

  void logout() {
    setState(() {
      _auth.signOut();
      userEmail = "no user";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userEmail == "no user") {
      return PreLoggedInProfile(
        setUser: setUser,
      );
    } else {
      return LoggedInProfile(
        logout: logout,
      );
    }
  }
}

class LoggedInProfile extends StatelessWidget {
  final Function logout;

  LoggedInProfile({required this.logout});

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
                Icon(
                  Icons.apartment_sharp,
                  size: 30.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "My Properties",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaNegative",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
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
                if (rentals.isEmpty) {
                  return SizedBox(
                    height: 220.0,
                  );
                }
                List<UserListingCard> cards = [];
                for (var rental in rentals) {
                  final card = UserListingCard(
                      rent: rental.get("rent"),
                      beds: rental.get("bedrooms"),
                      name: rental.get("name"),
                      address: rental.get("address"));
                  cards.add(card);
                }
                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: cards,
                );
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            RoundedButton(
              title: "Post a listing",
              color: Colors.lightBlueAccent.shade400,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostListing()),
                );
              },
            ),
            RoundedButton(
              title: "Log out",
              color: Colors.red.shade400,
              onPressed: () {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserListingCard extends StatelessWidget {
  final int rent;
  final int beds;
  final String name;
  final String address;

  UserListingCard(
      {required this.rent,
      required this.beds,
      required this.name,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                "https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=1170&fbclid=IwAR0olI3qR-ezelZl1zj4jV17Ud1me6DgBIw1jKBotiQmKOMgxg6nqpxTD6E"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money_rounded, size: 18),
                        Text(
                          rent.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.bed_rounded, size: 15),
                        SizedBox(width: 3),
                        Text(beds.toString() + " Beds"),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.apartment_rounded, size: 15),
                      SizedBox(width: 2),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 15),
                      SizedBox(width: 2),
                      Text(
                        address,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreLoggedInProfile extends StatelessWidget {
  final Function setUser;
  PreLoggedInProfile({required this.setUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundedButton(
            title: "Log In",
            color: Colors.lightBlueAccent,
            onPressed: () async {
              String userEmail = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              ) as String;
              setUser(userEmail);
            },
          ),
          RoundedButton(
            title: "Register",
            color: Colors.blueAccent,
            onPressed: () async {
              String userEmail = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              ) as String;
              setUser(userEmail);
            },
          ),
        ],
      ),
    );
  }
}
