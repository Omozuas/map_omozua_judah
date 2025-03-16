import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowController {
  OverlayEntry? overlayEntry;
  void showInfoWindow(BuildContext context, LatLng position, String title) {
    hideInfoWindow(); // Remove previous overlay if exists

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 300, // Adjust based on marker position
            left: 100,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("📍 Location details here"),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        log("Navigate pressed");
                        hideInfoWindow();
                      },
                      child: Text("Navigate"),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void hideInfoWindow() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
