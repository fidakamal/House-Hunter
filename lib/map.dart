import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:house_hunter/listing_card.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Map extends StatelessWidget {
  const Map({Key? key,}) : super(key: key);
  final Offset popupOffset = const Offset(0, -120);

  @override
  Widget build(BuildContext context) {
    List<LatLng> markers = [LatLng(23.7937, 90.4066), LatLng(23.8037, 90.4166)];
    return FlutterMap(
      options: MapOptions(
        center: LatLng(23.7937, 90.4066),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://tile.tracestrack.com/en/{z}/{x}/{y}.png?key=${dotenv.env['MAP_KEY'] ?? ""}",
        ),
        MarkerLayerOptions(
          rotate: true,
          markers: markers.map((marker) => Marker(
              width: 80.0,
              height: 80.0,
              point: marker,
              builder: (context) => PopupMenuButton(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  offset: popupOffset,
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(child: ListingCard(),
                    ),
                  ],
              )
            ),
          ).toList(),
        ),
      ],
    );
  }
}
