import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:house_hunter/listing_card.dart';
import 'package:house_hunter/search.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class Map extends StatelessWidget {
  final Offset popupOffset = const Offset(0, -120);
  final MapController mapController = MapController();
  bool mapReady = false;

  void moveMap(LatLng center) {
    if (mapReady && mapController.center != center) {
      mapController.moveAndRotate(center, 15.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Search>(builder: (context, search, child) {
      moveMap(search.center);
      mapController.onReady.then((value) {
        if (!mapReady) mapReady = true;
      });
      return FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(23.7937, 90.4066),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://tile.tracestrack.com/en/{z}/{x}/{y}.png?key=${dotenv.env['MAP_KEY'] ?? ""}",
          ),
          MarkerLayerOptions(
            rotate: true,
            markers: search.results
                .map(
                  (result) => Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(result['location']['geopoint'].latitude,
                          result['location']['geopoint'].longitude),
                      builder: (context) => PopupMenuButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            offset: popupOffset,
                            icon: Icon(
                              Icons.location_pin,
                              color: Colors.red[400],
                              size: 30,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: ListingCard(document: result),
                                  onTap: () {
                                    Provider.of<Navigation>(context,
                                            listen: false)
                                        .updateSelectedDocument(result);
                                    Provider.of<Navigation>(context,
                                            listen: false)
                                        .updateCurrentPage(PageName.result);
                                  }),
                            ],
                          )),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}
