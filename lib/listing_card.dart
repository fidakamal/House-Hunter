import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({Key? key}) : super(key: key);
  final String houseName = "House Name";
  final int price = 20000;
  final int beds = 3;
  final int baths = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(houseName, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.attach_money_rounded),
              const SizedBox(width: 5),
              Text(price.toString()),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.bed_rounded),
              const SizedBox(width: 5),
              Text(beds.toString()),
              const SizedBox(width: 20),
              const Icon(Icons.shower_outlined),
              const SizedBox(width: 5),
              Text(baths.toString()),
            ],
          )
        ],
      ),
    );
  }

}