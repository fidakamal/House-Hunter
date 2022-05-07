import 'package:flutter/material.dart';
import 'package:house_hunter/search.dart';
import 'package:house_hunter/search_filters.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> {
  String searchLocation = '';
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  IconButton? suffixButton() {
    if (textController.text != "") {
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => textController.text = "",
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Provider.of<Search>(context, listen: false).searchRentals(textController.text);
            },
          ),
          Expanded(
            child: TextField(
              controller: textController,
              onSubmitted: (value) => Provider.of<Search>(context, listen: false).searchRentals(textController.text),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search..."),
            ),
          ),
          if (suffixButton() != null) suffixButton()!,
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
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
