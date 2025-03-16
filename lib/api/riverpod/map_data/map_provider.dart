import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

final locationProvider = StateNotifierProvider<LocationNotifier, LatLng?>(
  (ref) => LocationNotifier(ref),
);

class LocationNotifier extends StateNotifier<LatLng?> {
  final Ref ref;

  LocationNotifier(this.ref) : super(null) {
    _determinePosition(); // Fetch location when provider initializes
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          log('Location permissions permanently denied');
          return;
        }
      }

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10, // Update only if user moves 10 meters
        ),
      ).listen((Position position) async {
        final newLocation = LatLng(position.latitude, position.longitude);
        state = newLocation;
        updateLocation(newLocation);
        if (ref.read(markerProvider).isEmpty) {
          ref.read(markerProvider.notifier).generateMarkers(newLocation);
        }
      });
    } catch (e) {
      log("Error fetching location: $e");
    }
  }

  ///  **Manually update user location when marker is dragged**
  void updateLocation(LatLng newLocation) {
    state = newLocation;
    final destination = ref.read(destinationProvider);
    if (destination != null) {
      ref
          .read(routeProvider.notifier)
          .fetchPolylinePoints(newLocation, destination);
    }
    _moveCamera(newLocation);
  }

  /// ✅ **Move camera to new position**
  Future<void> _moveCamera(LatLng newLocation) async {
    final controllerCompleter = ref.read(mapControllerProvider);
    if (!controllerCompleter.isCompleted) {
      log("GoogleMapController is not yet ready. Skipping camera update.");
      return; // ✅ Avoid crash if controller is not ready
    }
    final controller = await controllerCompleter.future;
    ref
        .read(cameraPositionProvider.notifier)
        .updateCameraPosition(controller, newLocation);
  }
}

final addressProvider = FutureProvider.family<String?, LatLng>((
  ref,
  position,
) async {
  log('hiii');
  final url = Uri.parse(
    "https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json",
  );
  final res = await http.get(url, headers: {"User-Agent": "mapping/1.0"});

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    log("${data['display_name']}");
    return data['display_name'];
  }
  return null;
});

final markerProvider = StateNotifierProvider<MarkerNotifier, List<LatLng>>((
  ref,
) {
  return MarkerNotifier();
});

class MarkerNotifier extends StateNotifier<List<LatLng>> {
  MarkerNotifier() : super([]);

  void generateMarkers(LatLng userLocation) {
    if (state.isEmpty) {
      state = _generateRandomPoints(userLocation, 7);
    }
  }

  List<LatLng> _generateRandomPoints(LatLng center, int count) {
    List<LatLng> points = [];
    math.Random random = math.Random();

    for (int i = 0; i < count; i++) {
      double latOffset = (random.nextDouble() - 0.5) * 0.02; // ±0.01°
      double lngOffset = (random.nextDouble() - 0.5) * 0.02; // ±0.01°
      points.add(
        LatLng(center.latitude + latOffset, center.longitude + lngOffset),
      );
    }

    return points;
  }
}

//  Route Provider to fetch & store polyline points
final routeProvider = StateNotifierProvider<RouteNotifier, List<LatLng>>(
  (ref) => RouteNotifier(),
);

class RouteNotifier extends StateNotifier<List<LatLng>> {
  RouteNotifier() : super([]);

  Future<void> fetchPolylinePoints(LatLng origin, LatLng destination) async {
    final String apiKey =
        "5b3ce3597851110001cf624832d96938e2e543f18a01778e098ef6eb";
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car?"
      "api_key=$apiKey&start=${origin.longitude},${origin.latitude}"
      "&end=${destination.longitude},${destination.latitude}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> coordinates =
          data["features"][0]["geometry"]["coordinates"];

      List<LatLng> polylinePoints =
          coordinates
              .map(
                (coord) => LatLng(coord[1], coord[0]),
              ) // Reverse order (lat, lng)
              .toList();

      state = polylinePoints; // ✅ Update state
      log("Route updated: ${state.length} points");
    } else {
      log("Error fetching route: ${response.body}");
    }
  }
}

final cameraPositionProvider =
    StateNotifierProvider<CameraPositionNotifier, CameraPosition?>(
      (ref) => CameraPositionNotifier(),
    );

class CameraPositionNotifier extends StateNotifier<CameraPosition?> {
  CameraPositionNotifier() : super(null);

  Future<void> updateCameraPosition(
    GoogleMapController controller,
    LatLng newPosition,
  ) async {
    CameraPosition newCameraPosition = CameraPosition(
      target: newPosition,
      zoom: 16,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
    state = newCameraPosition;
  }
}

final mapControllerProvider = Provider<Completer<GoogleMapController>>(
  (ref) => Completer<GoogleMapController>(),
);

///  Store Selected Destination
final destinationProvider = StateProvider<LatLng?>((ref) => null);
