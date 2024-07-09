import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad3_finals_tuba/services/firestore_service.dart';
import 'package:mad3_finals_tuba/views/screens/view_journal.dart';

class MapScreen extends StatefulWidget {
  static const String route = "/map";
  static const String path = "/map";
  static const String name = "Map Screen";
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.293371, 123.861406), // Coordinates for Cebu City
    zoom: 12.0,
  );

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _fetchJournalEntries();
  }

  Future<void> _fetchJournalEntries() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final journalEntries =
            await FirestoreService().getJournalEntries(user.uid);

        List<Marker> markers = [];
        for (var entry in journalEntries) {
          final location = entry['location'] as GeoPoint?;
          if (location != null) {
            markers.add(
              Marker(
                markerId: MarkerId(entry['id']),
                position: LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(
                  title: entry['title'],
                  snippet: entry['description'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewJournal(journalId: entry['id']),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }

        setState(() {
          _markers = markers;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load journal entries: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
      ),
    );
  }
}
