//   LatLng? locationss;
//   LatLng? selectedPosition;
//   LatLng? distnation1;
//   String? currentAddress;
//   String? distnationAddresss;
//   final Completer<GoogleMapController> mapController =
//       Completer<GoogleMapController>();
//   late Stream<Position> positionStream;
//   @override
//   void initState() {
//     super.initState();
//     log('$locationss');
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     log('load....');
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       log('load....1');
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         log('load....2'); // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       log('load....3'); // Permissions are denied forever, handle appropriately.
//       return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.',
//       );
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     // Start listening to location changes
//     log('load....4');
//     positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 10, // Update only if user moves 10 meters
//       ),
//     );

//     positionStream.listen((Position position) {
//       log('load....5');
//       LatLng currentLocation = LatLng(position.latitude, position.longitude);
//       log("New Location: $currentLocation");

//       setState(() {
//         locationss = currentLocation;
//         _cameraToPosition(currentLocation);
//       });
//       // ✅ Add random markers only once
//       if (!_markersAdded) {
//         _addRandomMarkers(currentLocation);
//         _markersAdded = true; // Prevent duplicate calls
//       }
//       // Call function to get address from location
//       getAddress(postion: currentLocation);

//       getPolylinsPoints(
//         origin: PointLatLng(
//           currentLocation.latitude,
//           currentLocation.longitude,
//         ),
//       ).then((onValue) {
//         generateplines(onValue);
//       });
//     });
//   }

//   void getAddress({required LatLng postion}) async {
//     final url = Uri.parse(
//       // 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${postion.latitude},${ postion.longitude }&key=YOUR_API_KEY',
//       "https://nominatim.openstreetmap.org/reverse?lat=${postion.latitude}&lon=${postion.longitude}&format=json",
//     );
//     final res = await http.get(
//       url,
//       headers: {
//         "User-Agent": "mapping/1.0 (iyanuomozua@gmail.com)", // REQUIRED
//       },
//     );
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       log("${data['display_name']}");
//       setState(() {
//         currentAddress = data['display_name'];
//       });
//       log("${data['address']}");
//     }
//   }

//   void distnationAddress({required LatLng postion}) async {
//     final url = Uri.parse(
//       // 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${postion.latitude},${ postion.longitude }&key=YOUR_API_KEY',
//       "https://nominatim.openstreetmap.org/reverse?lat=${postion.latitude}&lon=${postion.longitude}&format=json",
//     );
//     final res = await http.get(
//       url,
//       headers: {
//         "User-Agent": "mapping/1.0 (iyanuomozua@gmail.com)", // REQUIRED
//       },
//     );
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       log("${data['display_name']}");
//       setState(() {
//         distnationAddresss = data['display_name'];
//       });
//       log("${data['address']}");
//     }
//   }

//   Map<PolylineId, Polyline> plines = {};
//   // Generate random points within ±0.01° (approx. 1.1km)
//   List<LatLng> generateRandomPoints(LatLng center, int count) {
//     List<LatLng> points = [];
//     math.Random random = math.Random();

//     for (int i = 0; i < count; i++) {
//       double latOffset = (random.nextDouble() - 0.5) * 0.02; // ±0.01°
//       double lngOffset = (random.nextDouble() - 0.5) * 0.02; // ±0.01°
//       points.add(
//         LatLng(center.latitude + latOffset, center.longitude + lngOffset),
//       );
//     }

//     return points;
//   }

//   List<LatLng> _markers = []; // Store the markers
//   bool _markersAdded = false; // Prevents duplicate marker generation
//   void _addRandomMarkers(LatLng userLocation) {
//     final randomPoints = generateRandomPoints(userLocation, 7);

//     setState(() {
//       _markers.clear();
//       _markers = randomPoints;
//     });
//   }

//   // void _showNavigationDialog(
//   //   BuildContext context,
//   //   WidgetRef ref,
//   //   LatLng destination,
//   // ) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: Text("Navigate to this location?"),
//   //         content: Text(
//   //           "Start navigation from your current location. to $distnationAddresss",
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () => Navigator.pop(context),
//   //             child: Text("Cancel"),
//   //           ),
//   //           TextButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 distnation1 = destination;
//   //                 log("$distnation1 my distnation");
//   //                 distnationAddress(postion: distnation1!);
//   //               });

//   //               ref
//   //                   .read(navigationHistoryProvider.notifier)
//   //                   .addHistory(
//   //                     "$currentAddress",
//   //                     "Point at $distnationAddresss",
//   //                   );
//   //               getPolylinsPoints(
//   //                 origin: PointLatLng(
//   //                   locationss!.latitude,
//   //                   locationss!.longitude,
//   //                 ),
//   //               ).then((onValue) {
//   //                 generateplines(onValue);
//   //               });
//   //               Navigator.pop(context);
//   //             },
//   //             child: Text("Navigate"),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//  Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController _controller = await mapController.future;
//     CameraPosition _cameraPosition = CameraPosition(target: pos, zoom: 15);
//     await _controller.animateCamera(
//       CameraUpdate.newCameraPosition(_cameraPosition),
//     );
//   }

//   Future<List<LatLng>> getPolylinsPoints({required PointLatLng origin}) async {
//     List<LatLng> polylinecords = [];

//     final url = Uri.parse(
//       // "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=AIzaSyBbbkOUIl_XF_Al4hm-YsYuLZi57Y3N7Us",
//       "https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf624832d96938e2e543f18a01778e098ef6eb&start=${origin.longitude},${origin.latitude}&end=${distnation1?.longitude ?? 0},${distnation1?.latitude ?? 0}",
//     );
//     final res = await http.get(url);
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);

//       // Extract the coordinates from the response
//       List<dynamic> coordinates =
//           data["features"][0]["geometry"]["coordinates"];
//       log("$coordinates cc");
//       for (var coord in coordinates) {
//         double lng = coord[0]; // Longitude first
//         double lat = coord[1]; // Latitude second
//         polylinecords.add(LatLng(lat, lng));
//       }
//     } else {
//       log("Error fetching route: ${res.body}");
//     }

//     return polylinecords;
//   }

//   void generateplines(List<LatLng> p) async {
//     PolylineId id = PolylineId("poly");
//     Polyline polygon = Polyline(
//       polylineId: id,
//       color: Colors.black,
//       points: p,
//       width: 8,
//     );
//     setState(() {
//       plines[id] = polygon;
//     });
//   }

//   @override
//   bool get wantKeepAlive => true; // ✅ Keeps the state when switching tabs
