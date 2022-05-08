import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:house_hunter/search.dart';
import 'package:provider/provider.dart';

class SearchFilters extends StatefulWidget {
  const SearchFilters({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchFilters();
}

class _SearchFilters extends State<SearchFilters> {
  List<int> rooms = [for (var i = 1; i <= 5; i++) i];
  List<int> baths = [for (var i = 1; i <= 4; i++) i];
  RangeValues priceRange = const RangeValues(0, 10000);

  RangeValues selectedPriceRange = const RangeValues(0, 10000);
  GroupButtonController roomController = GroupButtonController();
  GroupButtonController bathController = GroupButtonController();
  late Search search;

  @override
  void initState() {
    super.initState();
    search = Provider.of<Search>(context, listen: false);
    roomController.selectIndexes(search.rooms);
    bathController.selectIndex(search.baths);
    selectedPriceRange = search.priceRange;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Price Range", style: TextStyle(fontSize: 20)),
          RangeSlider(
              labels: RangeLabels(selectedPriceRange.start.toStringAsFixed(0), selectedPriceRange.end.toStringAsFixed(0)),
              min: priceRange.start,
              max: priceRange.end,
              divisions: 1000,
              values: selectedPriceRange,
              onChanged: (RangeValues newRange) {
                setState(() => selectedPriceRange = newRange);
              }
          ),
          const Text("No. of Rooms", style: TextStyle(fontSize: 20)),
          Container(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: GroupButton(
              controller: roomController,
              isRadio: false,
              buttons: rooms,
              options: groupButtonOptions(),
            ),
          ),
          const Text("No. of Baths", style: TextStyle(fontSize: 20)),
          Container(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: GroupButton(
              controller: bathController,
              isRadio: true,
              buttons: baths.map((item) => item.toString() + "+").toList(),
              options: groupButtonOptions(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () => updateFilters(context),
                  child: Text("Search", style: TextStyle(fontSize: 16))
              ),
              SizedBox(width: 20),
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () => resetFilters(),
                  child: Text("Clear", style: TextStyle(fontSize: 16))
              )
            ],
          )
        ],
      ),
    );
  }

  void updateFilters(BuildContext context) {
    search.updateFilters(
        roomController.selectedIndexes.toList(),
        bathController.selectedIndex ?? 0,
        selectedPriceRange
    );
    Navigator.pop(context);
    search.searchRentals(search.lastSearch);
  }

  void resetFilters() {
    setState(() {
      roomController.unselectAll();
      bathController.selectIndex(0);
      selectedPriceRange = RangeValues(0, 10000);
    });
    search.clearFilters();
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
        fixedSize: Size(120, 60),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    );
  }

  GroupButtonOptions groupButtonOptions() {
    return GroupButtonOptions(
      runSpacing: 0,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      unselectedColor: Colors.black38,
    );
  }
}