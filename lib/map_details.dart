import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  String administrativeArea = "";
  String postalCode = "";
  String country = "";
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController sttController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";

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
    print("Place: $place");

    setState(() {
      houseController.text = place.subThoroughfare ?? '';
      areaController.text = place.thoroughfare ?? '';
      pinCodeController.text = place.postalCode ?? '';
      landmarkController.text = place.subLocality ?? '';
      locality = place.locality ?? '';
      subLocality = place.subLocality ?? '';
      administrativeArea = place.administrativeArea ?? '';
      postalCode = place.postalCode ?? '';
      country = place.country ?? '';
    });
  }

void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _spokenText = val.recognizedWords;
          sttController.text = _spokenText;
        }),
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // title: const Text('Map Details'),
          flexibleSpace: FlexibleSpaceBar(
            background: GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 10.0,
              ),
              // markers: {
              //   Marker(
              //     markerId: const MarkerId('selected-location'),
              //     position: LatLng(widget.latitude, widget.longitude),
              //   ),
              // },
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              myLocationButtonEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   height: MediaQuery.of(context).size.height * 0.1,
            //   child: GoogleMap(
            //     mapType: MapType.terrain,
            //     initialCameraPosition: CameraPosition(
            //       target: LatLng(widget.latitude, widget.longitude),
            //       zoom: 15.0,
            //     ),
            //     markers: {
            //       Marker(
            //         markerId: const MarkerId('selected-location'),
            //         position: LatLng(widget.latitude, widget.longitude),
            //       ),
            //     },
            //     zoomControlsEnabled: false,
            //     zoomGesturesEnabled: false,
            //     scrollGesturesEnabled: false,
            //     myLocationButtonEnabled: false,
            //     tiltGesturesEnabled: false,
            //     rotateGesturesEnabled: false,
            //     mapToolbarEnabled: false,
            //   ),
            // ),
            // const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
                Expanded(
                  flex: 11,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subLocality.isNotEmpty ? subLocality : locality,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${subLocality.isNotEmpty ? subLocality : locality}, $locality, $administrativeArea - $postalCode, $country.",
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: TextButton(
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //       child: const Text('Change'),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Card(
                    color: Color.fromARGB(255, 246, 228, 205),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'A detailed address will help our Delivery Partner reach your doorstep easily',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Address Details"),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  _buildTextFieldWithSpeechRecognition(
                      sttController, 'Speech to Text'),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Additional Information"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: additionalInfoController,
                    maxLines: 5, // Adjust the number of lines as needed
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 29, 96, 232))),
                        labelText: 'Additional Information',
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
                          backgroundColor: selectedButton == "Home"
                              ? Colors.blue
                              : Colors.white,
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
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithSpeechRecognition(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 29, 96, 232)),
        ),
        labelText: label,
        floatingLabelStyle:
            const TextStyle(color: Color.fromARGB(255, 29, 96, 232)),
        suffixIcon: IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
        ),
      ),
    );
  }
}
