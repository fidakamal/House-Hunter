import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  RangeValues priceRange = const RangeValues(0, 100000);

  RangeValues selectedPriceRange = const RangeValues(0, 100000);
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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Price Range",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "SignikaNegative",
                color: Colors.black54),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/taka.svg", height: 15, width: 15),
              Text(selectedPriceRange.start.toStringAsFixed(0).toString() +
                  " - "),
              SvgPicture.asset("assets/icons/taka.svg", height: 15, width: 15),
              Text(selectedPriceRange.end.toStringAsFixed(0).toString()),
            ],
          ),
          RangeSlider(
              activeColor: Colors.cyanAccent[700],
              inactiveColor: Colors.cyan[100],
              labels: RangeLabels(selectedPriceRange.start.toStringAsFixed(0),
                  selectedPriceRange.end.toStringAsFixed(0)),
              min: priceRange.start,
              max: priceRange.end,
              divisions: 10000,
              values: selectedPriceRange,
              onChanged: (RangeValues newRange) {
                setState(() => selectedPriceRange = newRange);
              }),
          SizedBox(
            height: 20,
          ),
          const Text(
            "No. of Bedrooms",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "SignikaNegative",
                color: Colors.black54),
          ),
          Container(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, left: 20, right: 20),
            child: GroupButton(
              controller: roomController,
              isRadio: false,
              buttons: rooms,
              options: groupButtonOptions(),
            ),
          ),
          const Text(
            "No. of Baths",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "SignikaNegative",
                color: Colors.black54),
          ),
          Container(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, left: 20, right: 20),
            child: GroupButton(
              controller: bathController,
              isRadio: true,
              buttons: baths.map((item) => item.toString() + "+").toList(),
              options: groupButtonOptions(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      style: buttonStyle(),
                      onPressed: () => updateFilters(context),
                      child: Text("Search", style: TextStyle(fontSize: 16))),
                ),
                SizedBox(width: 35),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      style: buttonStyle(),
                      onPressed: () => resetFilters(),
                      child: Text("Clear", style: TextStyle(fontSize: 16))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void updateFilters(BuildContext context) {
    search.updateFilters(roomController.selectedIndexes.toList(),
        bathController.selectedIndex ?? 0, selectedPriceRange);
    Navigator.pop(context);
    search.searchRentals(search.lastSearch);
  }

  void resetFilters() {
    setState(() {
      roomController.unselectAll();
      bathController.selectIndex(0);
      selectedPriceRange = RangeValues(0, 100000);
    });
    search.clearFilters();
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      primary: Colors.cyanAccent[700],
      //fixedSize: Size(120, 40),
      padding: EdgeInsets.only(top: 16, bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  GroupButtonOptions groupButtonOptions() {
    return GroupButtonOptions(
      runSpacing: 0,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      selectedColor: Colors.cyanAccent[700],
      unselectedColor: Colors.grey[300],
    );
  }
}
