import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:house_hunter/listing_card.dart';
import 'package:house_hunter/search.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:permission_handler/permission_handler.dart';

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Map();
}

class _Map extends State<Map> {
  final Offset popupOffset = const Offset(0, -120);
  final MapController mapController = MapController();
  bool mapReady = false;
  bool storageReady = false;
  late StorageCachingTileProvider cachingTileProvider;
  String tileProvider = "https://tile.tracestrack.com/en/{z}/{x}/{y}.png?key=${dotenv.env['MAP_KEY'] ?? ""}";

  void getCacheLocation() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        Directory directory = await getApplicationDocumentsDirectory();
        cachingTileProvider = StorageCachingTileProvider.fromMapCachingManager(
            MapCachingManager(directory, "Default Store")
        );
        setState(() => storageReady = true);
      }
    }
  }

  @override
  void iniState() {
    super.initState();
    getCacheLocation();
  }


  void moveMap(LatLng center) {
    if (mapReady && mapController.center != center) {
      mapController.moveAndRotate(center, 15.0, 0.0);
    }
  }

  void showError(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red.shade300,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              width: 250,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
              content: Text(
                "No rentals found in this area",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              )
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Search>(builder: (context, search, child) {
      if (search.lastSearch != "" && search.results.isEmpty && !search.loading
          && Provider.of<Navigation>(context).currentPage == PageName.map) {
        showError(context);
      }
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
            urlTemplate: tileProvider,
            tileProvider: storageReady ? cachingTileProvider : NonCachingNetworkTileProvider(),
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
