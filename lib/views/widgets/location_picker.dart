import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:mad3_finals_tuba/utils/constants.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.302450, 123.859485),
    zoom: 15.0,
  );

  LatLng? _selectedLocation;
  List<Marker> _markers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      _selectedLocation = position;
      _markers = [
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: "Selected Location",
          ),
        ),
      ];
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng position) {
                _addMarker(position, "New Marker");
              },
              markers: Set<Marker>.of(_markers),
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
                cursorColor: Colors.blue,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 60,
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
      appBar: AppBar(
        title: Text('Pick Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, _selectedLocation);
              },
            )
        ],
      ),
    );
  }
}
