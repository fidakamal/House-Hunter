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

  Widget? suffixButton() {
    if (Provider.of<Search>(context).loading) {
      return Container(
        margin: EdgeInsets.only(right: 15),
        child:
            SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
      );
    }
    if (textController.text != "") {
      return IconButton(
        icon: const Icon(
          Icons.clear,
          size: 20.0,
        ),
        onPressed: () => textController.text = "",
      );
    }
    return null;
  }

  void search() {
    Provider.of<Search>(context, listen: false)
        .searchRentals(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              size: 25.0,
            ),
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
          Expanded(
            child: TextField(
              controller: textController,
              onSubmitted: (value) => search(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search..."),
            ),
          ),
          if (suffixButton() != null) suffixButton()!,
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              size: 28.0,
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              search();
            },
          ),
        ],
      ),
    );
  }
}
