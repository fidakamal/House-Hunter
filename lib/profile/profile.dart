import 'package:flutter/material.dart';
import 'package:house_hunter/profile/pre_logged_in_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'logged_in_profile.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User loggedInUser;
  final _auth = FirebaseAuth.instance;
  String userEmail = "no user";

  void setUser(String email) {
    setState(() => userEmail = email);
  }

  @override
  void initState() {
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
      return PreLoggedInProfile(setUser: setUser);
    } else {
      return LoggedInProfile(logout: logout, userEmail: userEmail);
    }
  }
}
