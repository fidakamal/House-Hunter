import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
            Radius.circular(50)
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            splashColor: Colors.grey,
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          const Expanded(
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search..."
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text('RD'),
            ),
          ),
        ],
      ),
    );
  }
}