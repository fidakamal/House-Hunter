import 'package:flutter/material.dart';
import 'package:house_hunter/search_filters.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

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
            icon: const Icon(Icons.menu_rounded),
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
          IconButton(
            splashColor: Colors.grey,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              showMaterialModalBottomSheet<dynamic>(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const SearchFilters(),
              );
            },
          ),
        ],
      ),
    );
  }
}