import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/register.dart';
import 'package:house_hunter/components/rounded_button.dart';
import 'package:house_hunter/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house_hunter/post_listing.dart';
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
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Container(
                      child: Center(
                        child: Text(document['name']),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          RoundedButton(
            title: "Post a listing",
            color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostListing()),
              );
            },
          ),
          RoundedButton(
            title: "Log out",
            color: Colors.blueAccent,
            onPressed: () {
              logout();
            },
          ),
        ],
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
