import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mappingapp/api/riverpod/chate_data/chat_provider.dart';
import 'package:mappingapp/api/riverpod/history_data/history_data.dart';
import 'package:mappingapp/api/riverpod/map_data/map_provider.dart';
import 'package:mappingapp/common/app_style.dart';

//97
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(locationProvider);
    final markers = ref.watch(markerProvider);
    final polylinePoints = ref.watch(routeProvider);
    final cameraPosition = ref.watch(cameraPositionProvider);
    final mapControllerCompleter = ref.watch(mapControllerProvider);
    ref.watch(destinationProvider);
    ref.watch(navigationHistoryProvider);
    ref.watch(chatMessagesProvider);
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          userLocation == null
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) {
                        if (!mapControllerCompleter.isCompleted) {
                          mapControllerCompleter.complete(controller);
                        }
                      },
                      initialCameraPosition:
                          cameraPosition ??
                          CameraPosition(target: userLocation, zoom: 16),
                      markers: {
                        Marker(
                          markerId: MarkerId('current location'),
                          position: userLocation,
                          draggable: true,
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: InfoWindow(
                            title: "my location",
                            snippet: "Tap for navigation",
                          ),
                          onDragEnd: (value) async {
                            log("$value");
                            // getAddress(postion: value);
                            final fromAddress = await ref.read(
                              addressProvider(userLocation).future,
                            );
                            log("$fromAddress");

                            setState(() {
                              ref
                                  .read(locationProvider.notifier)
                                  .updateLocation(value);
                            });
                          },
                        ),
                        for (int i = 0; i < markers.length; i++)
                          Marker(
                            markerId: MarkerId('marker_$i'),
                            position: markers[i],
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              (i * 50) % 360,
                            ),
                            onTap:
                                () => _showNavigationDialog(
                                  context,
                                  ref,
                                  markers[i],
                                ),
                          ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: PolylineId("poly"),
                          color: Colors.black,
                          points: polylinePoints,
                          width: 5,
                        ),
                      },
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  void _showNavigationDialog(
    BuildContext context,
    WidgetRef ref,
    LatLng destination,
  ) async {
    final userLocation = ref.read(locationProvider);
    if (userLocation == null) return;
    final distance = _calculateDistance(userLocation, destination);

    final fromAddress = await ref.read(addressProvider(userLocation).future);
    final toAddress = await ref.read(addressProvider(destination).future);
    ref.read(destinationProvider.notifier).state = destination;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ), // Rounded Dialog
          contentPadding: EdgeInsets.all(16),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_pin, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "your location: $fromAddress   Destination: $toAddress",
                  style: appStyle(18, Colors.black87, FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Coordinates: ${destination.latitude.toStringAsFixed(4)}, ${destination.longitude.toStringAsFixed(4)}",
                style: appStyle(14, Colors.black87, FontWeight.normal),
              ),
              SizedBox(height: 8),
              Text(
                "Distance: ${distance.toStringAsFixed(2)} km",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(Icons.directions, color: Colors.white),
                      label: Text(
                        "Navigate",
                        style: appStyle(13, Colors.white, FontWeight.w400),
                      ),
                      onPressed: () {
                        // ✅ Fetch Polyline Points when "Navigate" is clicked
                        ref
                            .read(routeProvider.notifier)
                            .fetchPolylinePoints(userLocation, destination);

                        // ✅ Add to history
                        ref
                            .read(navigationHistoryProvider.notifier)
                            .addHistory(
                              fromAddress ?? "Unknown",
                              toAddress ?? "Unknown",
                            );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(Icons.close, color: Colors.white),
                      label: Text(
                        "close",
                        style: appStyle(13, Colors.white, FontWeight.w400),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ **Calculate Distance (Haversine Formula)**
  double _calculateDistance(LatLng start, LatLng end) {
    const double R = 6371; // Earth radius in km
    double dLat = (end.latitude - start.latitude) * (math.pi / 180);
    double dLon = (end.longitude - start.longitude) * (math.pi / 180);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(start.latitude * (math.pi / 180)) *
            math.cos(end.latitude * (math.pi / 180)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c; // Distance in km
  }

  @override
  bool get wantKeepAlive => true; // ✅ Keeps the state when switching tabs
}
