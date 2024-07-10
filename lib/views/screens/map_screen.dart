import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:mad3_finals_tuba/services/firestore_service.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/views/screens/view_journal.dart';
import 'package:mad3_finals_tuba/views/screens/new_journal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

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
    target: LatLng(10.293371, 123.881406), // Coordinates for Cebu City
    zoom: 13.0,
  );

  List<Marker> _markers = [];
  final TextEditingController _searchController = TextEditingController();

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

        for (var entry in journalEntries) {
          final location = entry['location'] as GeoPoint?;
          if (location != null) {
            final imageUrl =
                entry['images']?.isNotEmpty == true ? entry['images'][0] : null;
            final markerIcon = await _createCustomMarkerBitmap(imageUrl);

            setState(() {
              _markers.add(
                Marker(
                  markerId: MarkerId(entry['id']),
                  position: LatLng(location.latitude, location.longitude),
                  icon: markerIcon,
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
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load journal entries: $e'),
        ),
      );
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(String? imageUrl) async {
    if (imageUrl == null) {
      return BitmapDescriptor.defaultMarker;
    }

    final ByteData data =
        await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
    final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 200,
        targetHeight: 200);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double size = 200.0;

    // Draw the circle with black border
    final Paint paintCircle = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paintCircle);

    // Draw the image inside the circle
    final Rect rect = Rect.fromCircle(
        center: Offset(size / 2, size / 2), radius: (size / 2) - 4);
    final RRect rrect =
        RRect.fromRectAndRadius(rect, Radius.circular(size / 2 - 4));
    canvas.clipRRect(rrect);
    paintImage(
      canvas: canvas,
      image: fi.image,
      rect: rect,
      fit: BoxFit.cover,
    );

    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }

  Future<void> _goToCurrentLocation() async {
    Position position = await _determinePosition();
    final GoogleMapController controller = await _controller.future;
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    controller.animateCamera(CameraUpdate.newLatLngZoom(
      currentLatLng,
      18.0,
    ));
    _addMarker(currentLatLng, "Current Location");
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  void _addMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          draggable: true,
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: "Tap to Add Journal Entry",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewJournal(
                    initialLocation: position,
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(_markers),
              onTap: (LatLng position) {
                _addMarker(position, "New Marker");
              },
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: GooglePlaceAutoCompleteTextField(
                  boxDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(88.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  textEditingController: _searchController,
                  googleAPIKey: "AIzaSyCnZK-0SUxt_xnlXJXTMRqBaTb1WLjAvk4",
                  inputDecoration: InputDecoration(
                    hintText: "Search a location",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                    prefixIcon: Icon(Icons.search),
                  ),
                  debounceTime: 800,
                  countries: ["ph"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) async {
                    final lat = double.parse(prediction.lat!);
                    final lng = double.parse(prediction.lng!);
                    final GoogleMapController controller =
                        await _controller.future;
                    LatLng position = LatLng(lat, lng);
                    controller.animateCamera(CameraUpdate.newLatLngZoom(
                      position,
                      18.0,
                    ));
                    _addMarker(position, prediction.description!);
                  },
                  itemClick: (Prediction prediction) {
                    _searchController.text = prediction.description ?? "";
                    _searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0),
                    );
                  },
                  cursorColor: Colors.blue),
            ),
            Positioned(
              bottom: 100,
              right: 10,
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
                backgroundColor: Constants.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
