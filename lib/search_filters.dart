import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class SearchFilters extends StatefulWidget {
  const SearchFilters({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchFilters();
}

class _SearchFilters extends State<SearchFilters> {
  List<int> rooms = [for (var i = 1; i <= 5; i++) i];
  List<int> baths = [for (var i = 1; i <= 4; i++) i];
  RangeValues priceRange = const RangeValues(0, 10000);

  List<int> selectedRooms = [0, 1, 2];
  int selectedBaths = 2;
  RangeValues selectedPriceRange = const RangeValues(0, 5000);

  @override
  Widget build(BuildContext context) {
    GroupButtonController roomController = GroupButtonController(selectedIndexes: selectedRooms);
    GroupButtonController bathController = GroupButtonController(selectedIndex: selectedBaths);

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
                setState(() {
                  selectedPriceRange = newRange;
                });
              }
          ),
          const Text("No. of Rooms", style: TextStyle(fontSize: 20)),
          Container(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: GroupButton(
              controller: roomController,
              isRadio: false,
              buttons: rooms,
              options: const GroupButtonOptions(
                runSpacing: 0,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                unselectedColor: Colors.black38,
              ),
            ),
          ),
          const Text("No. of Baths", style: TextStyle(fontSize: 20)),
          Container(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: GroupButton(
              controller: bathController,
              isRadio: true,
              buttons: baths.map((item) => item.toString() + "+").toList(),
              options: const GroupButtonOptions(
                runSpacing: 0,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                unselectedColor: Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

}