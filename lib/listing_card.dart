import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(document['name'], style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.attach_money_rounded),
              const SizedBox(width: 5),
              Text(document['rent'].toString()),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.bed_rounded),
              const SizedBox(width: 5),
              Text(document['bedrooms'].toString()),
              const SizedBox(width: 20),
              const Icon(Icons.shower_outlined),
              const SizedBox(width: 5),
              Text(document['baths'].toString()),
            ],
          )
        ],
      ),
    );
  }

}