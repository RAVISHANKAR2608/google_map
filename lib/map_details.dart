import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetails extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapDetails(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<MapDetails> createState() => _MapDetailsState();
}

class _MapDetailsState extends State<MapDetails> {
  String selectedButton = "";
  String subLocality = "";
  String locality = "";
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAddressDetails();
  }

  void _onButtonPressed(String buttonType) {
    setState(() {
      selectedButton = buttonType;
    });
  }

  void _getAddressDetails() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(widget.latitude, widget.longitude);
    Placemark place = placemarks[0];

    setState(() {
      houseController.text = place.subThoroughfare ?? '';
      areaController.text = place.thoroughfare ?? '';
      pinCodeController.text = place.postalCode ?? '';
      landmarkController.text = place.subLocality ?? '';
      locality = place.locality ?? '';
      subLocality = place.subLocality ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 15.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: LatLng(widget.latitude, widget.longitude),
                    ),
                  },
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.map, color: Colors.blue),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subLocality,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          locality,
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
              const SizedBox(height: 20),
              const Text("Address Details"),
              const SizedBox(height: 10),
              TextField(
                controller: houseController,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 29, 96, 232))),
                    labelText: 'House / Street No.',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 29, 96, 232))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: areaController,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 29, 96, 232))),
                    labelText: 'Area Name',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 29, 96, 232))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pinCodeController,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 29, 96, 232))),
                    labelText: 'PinCode',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 29, 96, 232))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: landmarkController,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 29, 96, 232))),
                    labelText: 'Landmark',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 29, 96, 232))),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _onButtonPressed("Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedButton == "Home" ? Colors.blue : Colors.white,
                    ),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: selectedButton == "Home"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _onButtonPressed("Office"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == "Office"
                          ? Colors.blue
                          : Colors.white,
                    ),
                    child: Text(
                      'Office',
                      style: TextStyle(
                        color: selectedButton == "Office"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _onButtonPressed("Others"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedButton == "Others"
                          ? Colors.blue
                          : Colors.white,
                    ),
                    child: Text(
                      'Others',
                      style: TextStyle(
                        color: selectedButton == "Others"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/',
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
