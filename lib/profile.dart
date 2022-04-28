import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/register.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: TextButton(
          child: Text(
            "Create an account to add rent listing",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register()),
            );
          },
        ),
      ),
    );
  }
}
