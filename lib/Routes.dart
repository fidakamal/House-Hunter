import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/listing.dart';
import 'package:house_hunter/messaging/message_list.dart';
import 'package:house_hunter/search_bar.dart';
import 'package:house_hunter/map.dart';
import 'package:house_hunter/list_view.dart';
import 'package:provider/provider.dart';
import 'package:house_hunter/profile/profile.dart';
import 'package:house_hunter/search.dart';

class Routes extends StatefulWidget {
  Routes({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Routes();
}

class _Routes extends State<Routes> {
  @override
  void dispose() {
    super.dispose();
    Provider.of<Search>(context, listen: false).textController.dispose();
  }

  Widget mapPage() {
    return Stack(
      children: [
        Map(),
        SafeArea(
          child: SearchBar(
              textController: Provider.of<Search>(context).textController),
        ),
      ],
    );
  }

  Widget listViewPage() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SearchBar(
              textController: Provider.of<Search>(context).textController),
          ResultsListView(),
        ],
      ),
    );
  }

  Widget resultPage() {
    return SafeArea(child: Listing());
  }

  Widget profilePage() {
    return SafeArea(
      child: Profile(),
    );
  }

  Widget messages() {
    return SafeArea(
      child: MessageList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, navigation, child) {
      return IndexedStack(
        index: navigation.currentPage.index,
        children: [mapPage(), listViewPage(), resultPage(), profilePage(), messages()],
      );
    });
  }
}
