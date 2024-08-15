import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map/google_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/map': (BuildContext context) => const MapSample(),
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            // DraggableScrollable ()
            _showModalBottomSheet(context);
            // showModalBottomSheet(
            //   // enableDrag: true,
            //   context: context,
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(10.0),
            //         topRight: Radius.circular(10.0)),
            //   ),
            //   isScrollControlled: true,
            //   constraints: BoxConstraints.tight(Size(
            //       MediaQuery.of(context).size.width,
            //       MediaQuery.of(context).size.height * .9)),
            //   builder: (ctx) {
            //     return const SingleChildScrollView(
    
            //     );
            //   },
            // );
          },
          child: Row(
            children: [
              const Icon(
                Icons.location_pin,
                size: 28,
                color: Color.fromARGB(255, 255, 128, 0),
              ),
              const SizedBox(
                width: 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "kamalar",
                        style: GoogleFonts.outfit(
                          color: const Color.fromARGB(255, 55, 55, 55),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                      )
                    ],
                  ),
                  Text(
                    "kannaki",
                    style: GoogleFonts.outfit(
                      color: const Color.fromARGB(255, 109, 106, 114),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/user-suggestion");
              },
              child: const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.rate_review_outlined,
                      color: Color(0xFF1D60E8))),
            ),
          )
        ],
      ),
     body: Center(
      
        child: ElevatedButton(

          onPressed: () {
            Navigator.of(context).pushNamed('/map');
          },
          child: const Text('View Map'),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        ),
      ),
      // isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        
        return Scaffold(
          
          body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(MyApp);
                    },
                    // onTapDown: (details) {
                    //   print("object");
                    //   Navigator.pushNamed(context, "/");
                    // },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 30,
                          // weight: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Select a location",
                          style: GoogleFonts.outfit(
                            color: const Color(0XFF373737),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      TextField(
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            hintText: "Search for area streer name.... ",
                            helperStyle: const TextStyle(
                                color: Color.fromARGB(255, 244, 242, 242)),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.red,
                            ),
                            fillColor: const Color.fromARGB(255, 241, 239, 239),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 189, 186, 186)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              // borderSide: BorderSide(color: Color.fromARGB(255, 117, 117, 60)),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 233, 229, 229)),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white),
                    ),
                    elevation: 1,
                    child: Container(
                      height: 116,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                          color: const Color.fromARGB(255, 249, 244, 244)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("current location");
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.my_location,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Use current location",
                                        style: GoogleFonts.outfit(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      Text(
                                        "Kamarlar, Tiruchengode",
                                        style: GoogleFonts.outfit(
                                          color: const Color.fromARGB(
                                              255, 120, 116, 116),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color:
                                              Color.fromARGB(255, 139, 137, 137),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("add address");
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Add Address",
                                    style: GoogleFonts.outfit(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color.fromARGB(255, 139, 137, 137),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildDashedLined(context),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "RECENT LOCATION",
                          style: GoogleFonts.outfit(
                            letterSpacing: 2.0,
                            color: const Color.fromARGB(255, 151, 149, 149),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        buildDashedLined(context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    height: 200,
                    // color: Colors.amber,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, index) { 
                        return 
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.access_time, size: 20, color: Color.fromARGB(255, 158, 157, 156),),
                                    SizedBox(height: 5,),
                                    Text("0 m"),
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text("Kamalar"), 
                                                                      SizedBox(height: 5,),

                                  Text("Truchengode")],
                                )
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.access_time, size: 20, color: Color.fromARGB(255, 158, 157, 156),),
                                    SizedBox(height: 5,),
                                    Text("0 m"),
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text("Kamalar"), 
                                                                      SizedBox(height: 5,),

                                  Text("Truchengode")],
                                )
                              ],
                            ),
                          ],
                                            ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}

Widget buildDashedLined(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double lineLength = screenWidth * 0.25; // Adjust this factor as needed

  return Center(
    child: DottedLine(
      dashColor: const Color(0xFFDBDBDB),
      direction: Axis.horizontal,
      dashGapLength: 0,
      lineThickness: 1,
      dashLength: 4,
      lineLength: lineLength,
    ),
  );
}
