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

class _MapSampleState extends State<MapSample> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  double latValue = 11.380333491395136;
  double longValue = 77.89550084620714;
  bool isMapMoving = false;
  bool isLocationInfo = true;
  bool isMapLoading = true;
  String subLocality = "";
  String locality = "";

  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _initializeAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _animation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_animationController);

    _colorAnimation = ColorTween(
      begin: Colors.blue.withOpacity(1.0),
      end: Colors.blue.withOpacity(0.1),
    ).animate(_animationController);
  }

  void _startAnimation() {
    if (_animationController.isAnimating) {
      _animationController.reset();
    }
    _animationController.forward();
  }

  Future<void> _onCameraMove(CameraPosition position) async {
    setState(() {
      isMapMoving = true;
      latValue = position.target.latitude;
      longValue = position.target.longitude;
    });

    // Stop and restart the animation when the map is moving
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
  }

  Future<void> _onCameraIdle() async {
    setState(() {
      isMapMoving = false;
    });

    // Restart the animation from the beginning if the widget is still mounted
    if (mounted) {
      _startAnimation();
      _initializeAnimation();
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latValue, longValue);
    // print("Placemarks: $placemarks");
    Placemark place = placemarks[0];

    setState(() {
      locality = place.locality ?? '';
      subLocality = place.subLocality ?? '';
    });

    // String address =
    //     "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    // print("Address: $address");

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Address: $address")),
    //   );
    // }
  }

  Future<void> _searchPlaces(String query) async {
    List<Location> locations = await locationFromAddress(query);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      setState(() {
        latValue = location.latitude;
        longValue = location.longitude;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              await Future.delayed(const Duration(seconds: 2));
              controller
                  .showMarkerInfoWindow(const MarkerId('currentLocation'));
              controller.takeSnapshot();

              setState(() {
                isMapLoading = false;
              });
            },
            markers: {
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(latValue, longValue),
                infoWindow: !isLocationInfo
                    ? InfoWindow.noText
                    : const InfoWindow(title: 'Your Location'),
              ),
            },
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    // Show animated circle when map is not moving
                    return Visibility(
                      visible: !isMapLoading && !isMapMoving,
                      child: Container(
                        width: _animation.value * 100,
                        height: _animation.value * 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorAnimation.value,
                        ),
                      ),
                    );
                  },
                ),
                // const Icon(
                //   Icons.location_pin,
                //   size: 40,
                //   color: Colors.red,
                // ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Row(
              children: [
                Expanded(
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
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 36, 3, 82),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // padding: const EdgeInsets.all(16.0),
                  // elevation: 5.0,
                  // textStyle: const TextStyle(fontSize: 16.0),
                  // minimumSize: const Size.fromHeight(30.0),
                  // maximumSize: const Size.fromHeight(48.0),
                  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shadowColor: Colors.transparent,
                  // side: const BorderSide(color: Colors.black),
                  // backgroundColor: Colors.white,
                  // foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(latValue, longValue),
                      zoom: 14.0,
                    ),
                  ));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Color.fromARGB(255, 36, 3, 82),
                      size: 18,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Current Location'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Text(
                    "DELIVERY ADDRESS",
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.location_pin, color: Colors.red, size: 28,),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subLocality.isNotEmpty
                          ? [
                              Text(
                                subLocality,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                locality,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                          : [
                              Text(
                                locality,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Change'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text('Latitude: $latValue'),
            // Text('Longitude: $longValue'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
