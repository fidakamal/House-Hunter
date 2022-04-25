import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(23.7937, 90.4066),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(23.7937, 90.4066),
              builder: (context) => Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.red,
                  onPressed: () {
                    print("Marker Tapped");
                  },
                ),
              ),
            ),
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(23.8037, 90.4166),
              builder: (context) => Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.red,
                  onPressed: () {
                    print("Marker Tapped");
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
