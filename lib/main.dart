import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapApp(),
    );
  }
}

class MapApp extends StatefulWidget {
  const MapApp({super.key});

  @override
  State<MapApp> createState() => _MapAppState();
}

class Huette {
  late GeoPoint _geoPoint;
  late String _type;
  late Icon _icon;

  Huette(GeoPoint geoPoint, String type, Icon icon) {
    _geoPoint = geoPoint;
    _type = type;
    _icon = icon;
  }
}

class _MapAppState extends State<MapApp> {
  // define map controllers

  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(
      latitude: 51.340575,
      longitude: 12.374753,
    ),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  MapController customTilecontroller = MapController.customLayer(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(
      latitude: 51.340575,
      longitude: 12.374753,
    ),
    customTile: CustomTile(
      sourceName: "opentopomap",
      tileExtension: ".png",
      minZoomLevel: 2,
      maxZoomLevel: 19,
      urlsServers: [
        TileURLs(
          url: "https://tile.opentopomap.org/",
          subdomains: [],
        )
      ],
      tileSize: 256,
    ),
  );

  List<Huette> huettelist = [
    Huette(GeoPoint(latitude: 51.340575, longitude: 12.374753), 'house',
        const Icon(Icons.house)),
    Huette(GeoPoint(latitude: 51.340575, longitude: 12.374963), 'wine',
        const Icon(Icons.wine_bar)),
    Huette(GeoPoint(latitude: 51.340075, longitude: 12.374963), 'house',
        const Icon(Icons.house)),
    Huette(GeoPoint(latitude: 51.340075, longitude: 12.374763), 'wine',
        const Icon(Icons.wine_bar))
  ];

  int cAll = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OSMFlutter(
          controller: mapController,
          trackMyPosition: false,
          initZoom: 17,
          minZoomLevel: 2,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.transparent,
              child: const Text(
                'Weihnachtsmarkt Map',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  decorationColor: Colors.red,
                ),
              ),
            ),
          ),
        ),
        Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: FloatingActionButton(
                  onPressed: () {
                    if (cAll % 2 == 0) {
                      cAll += 1;
                      mapController.enableTracking(enableStopFollow: true);
                      for (var huette in huettelist) {
                        mapController.removeMarker(huette._geoPoint);
                        mapController.addMarker(
                          huette._geoPoint,
                          markerIcon: const MarkerIcon(
                            icon: Icon(
                              Icons.circle,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    } else {
                      cAll += 1;
                      for (var huette in huettelist) {
                        mapController.removeMarker(huette._geoPoint);
                        mapController.disabledTracking();
                      }
                    }
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.sunny),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: FloatingActionButton(
                  onPressed: () {
                    mapController.disabledTracking();
                    for (final huette in huettelist) {
                      mapController.removeMarker(huette._geoPoint);
                      cAll = 0;
                      if (huette._type == 'house') {
                        mapController.addMarker(
                          huette._geoPoint,
                          markerIcon: MarkerIcon(
                            icon: huette._icon,
                          ),
                        );
                      }
                    }
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.house),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: FloatingActionButton(
                  onPressed: () {
                    mapController.disabledTracking();
                    for (final huette in huettelist) {
                      mapController.removeMarker(huette._geoPoint);
                      cAll = 0;
                      if (huette._type == 'wine') {
                        mapController.addMarker(
                          huette._geoPoint,
                          markerIcon: MarkerIcon(
                            icon: huette._icon,
                          ),
                        );
                      }
                    }
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.wine_bar),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
