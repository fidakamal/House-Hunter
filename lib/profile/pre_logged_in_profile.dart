import 'package:flutter/material.dart';
import 'package:house_hunter/profile/register.dart';
import 'package:house_hunter/components/rounded_button.dart';
import 'package:house_hunter/profile/login.dart';

class PreLoggedInProfile extends StatelessWidget {
  final Function setUser;
  PreLoggedInProfile({required this.setUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundedButton(
            title: "Log In",
            color: Colors.cyan.shade300,
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
            color: Colors.cyanAccent.shade700,
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
