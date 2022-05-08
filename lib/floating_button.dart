import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.gps_fixed_rounded),
      backgroundColor: Colors.cyanAccent[400],
    );
  }
}
