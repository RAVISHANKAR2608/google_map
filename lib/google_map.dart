import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map/map_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  double latValue = 11.3753926;
  double longValue = 77.8938889;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onMapTap(LatLng latLng) async {
    setState(() {
      latValue = latLng.latitude;
      longValue = latLng.longitude;
    });
    print("Co-ordinates : $latValue, $longValue");

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latValue, longValue);
    print("Placemarks : $placemarks");
    Placemark place = placemarks[0];

    String address =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    print("Address: $address");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Address: $address")),
    );
  }

    Future<void> _searchPlaces(String query) async {
    List<Location> locations = await locationFromAddress(query);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      setState(() {
        latValue = location.latitude!;
        longValue = location.longitude!;
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latValue, longValue),
          zoom: 14.0,
        ),
      ));
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.380008, 77.8953203),
    zoom: 14.4746,
  );

  Marker _kGooglePlexMarker() {
    return Marker(
      markerId: const MarkerId('_kGooglePlexMarker'),
      infoWindow: const InfoWindow(title: 'Ravi'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(latValue, longValue),
    );
  }

  Circle _kGooglePlexCircle() {
    return Circle(
      circleId: const CircleId('_kGooglePlexCircle'),
      center: LatLng(latValue, longValue), // Center of the circle
      radius: 1000, // Radius in meters
      strokeWidth: 2, // Width of the circle's outline
      strokeColor: Colors.blue, // Color of the circle's outline
      fillColor: Colors.blue
          .withOpacity(0.5), // Fill color of the circle with transparency
    );
  }

  static final Marker _klakeMarker = Marker(
    markerId: const MarkerId('_klakeMarker'),
    infoWindow: const InfoWindow(title: 'PeriyaKottapalayam'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    position: const LatLng(11.4186308, 77.9427329),
  );

  // static const Polygon _kPolygon = Polygon(
  //   polygonId: PolygonId('_kPolygon'),
  //   points: [
  //     LatLng(11.4186308, 77.9427329),
  //     LatLng(11.380008, 77.8953203),
  //     LatLng(30.3800200, 77.8953305),
  //     LatLng(12.380300, 77.8953403),
  //   ],
  //   strokeWidth: 5,
  //   strokeColor: Colors.pink,
  //   fillColor: Colors.yellow,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  // child: TextFormField(
                  //   controller: __searchController,
                  //   textCapitalization: TextCapitalization.words,
                  //   decoration: const InputDecoration(
                  //     hintText: "Search",
                  //   ),
                  // ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchPlaces,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.cancel_outlined,
                                  color: Color(0xFF6D6A72)),
                              onPressed: () {
                                _searchController.clear();
                                _searchPlaces('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.only(top: 12.0),
                      border: InputBorder.none,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     // Handle search action
                //   },
                //   icon: const Icon(Icons.search),
                // )
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              // markers: {_kGooglePlexMarker(), _klakeMarker},
              onTap: _onMapTap,
              // polygons: {_kPolygon},
              initialCameraPosition: _kGooglePlex,
              markers: <Marker>{_kGooglePlexMarker()},
              // circles: <Circle>{_kGooglePlexCircle()},
              // polygons: <Polygon>{_kGooglePlexPolygon},
              // polylines: <Polyline>{_kPolyline},
              // myLocationEnabled: true,
              // myLocationButtonEnabled: true,
              // zoomControlsEnabled: true,
              // zoomGesturesEnabled: true,
              // scrollGesturesEnabled: true,
              // tiltGesturesEnabled: true,
              // rotateGesturesEnabled: true,
              // mapToolbarEnabled: true,
              // onLongPress: (latLng) {
              //   _onMapTap(latLng);
              // }

              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapDetails(
                  latitude: latValue,
                  longitude: longValue,
                ),
              ),
            );
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
