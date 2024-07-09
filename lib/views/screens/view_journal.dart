import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mad3_finals_tuba/services/firestore_service.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/views/widgets/location_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewJournal extends StatefulWidget {
  static const String route = "/viewjournal";
  static const String path = "/viewjournal";
  static const String name = "View Journal Screen";
  final String journalId;

  const ViewJournal({Key? key, required this.journalId}) : super(key: key);

  @override
  _ViewJournalState createState() => _ViewJournalState();
}

class _ViewJournalState extends State<ViewJournal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<XFile> _images = [];
  List<String> _imageUrls = [];
  final ImagePicker _picker = ImagePicker();
  LatLng? _selectedLocation;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchJournal();
  }

  Future<void> _fetchJournal() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final journalData = await FirestoreService()
            .getJournalEntry(user.uid, widget.journalId);
        setState(() {
          _titleController.text = journalData['title'] ?? '';
          _descriptionController.text = journalData['description'] ?? '';
          _imageUrls = List<String>.from(journalData['images'] ?? []);
          final location = journalData['location'] as GeoPoint?;
          if (location != null) {
            _selectedLocation = LatLng(location.latitude, location.longitude);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load journal: $e'),
        ),
      );
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(color: Constants.primaryColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      labelStyle: TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  TextStyle _buildTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 16.0,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  Future<void> _chooseLocation(BuildContext context) async {
    final location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );
    if (location != null && location is LatLng) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    for (var image in _images) {
      final storageRef =
          FirebaseStorage.instance.ref().child('journal_images/${image.name}');
      final uploadTask = await storageRef.putFile(File(image.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  Future<void> _saveJournal() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedLocation == null ||
        (_images.isEmpty && _imageUrls.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields and add at least one image'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found.");
      }
      final uid = user.uid;

      final newImageUrls = await _uploadImages();
      final allImageUrls = [..._imageUrls, ...newImageUrls];

      final journalData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'images': allImageUrls,
        'location': GeoPoint(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
        ),
      };

      await FirestoreService()
          .updateJournalEntry(uid, widget.journalId, journalData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Journal entry updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating journal entry: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _deleteJournal() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found.");
      }
      final uid = user.uid;

      await FirestoreService().deleteJournalEntry(uid, widget.journalId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Journal entry deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting journal entry: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to delete an image from the list
  void _deleteImage(int index) {
    if (index < _imageUrls.length) {
      setState(() {
        _imageUrls.removeAt(index);
      });
    } else {
      setState(() {
        _images.removeAt(index - _imageUrls.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Journal'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_isEditing)
            IconButton(
              padding: EdgeInsets.only(right: 16),
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteJournal,
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length + _imageUrls.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _images.length + _imageUrls.length) {
                      return GestureDetector(
                        onTap: _isEditing ? _pickImage : null,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Icon(Icons.add,
                              size: 50, color: Colors.grey[700]),
                        ),
                      );
                    } else if (index < _imageUrls.length) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.0),
                              child: Image.network(_imageUrls[index],
                                  width: 250, height: 250, fit: BoxFit.cover),
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () => _deleteImage(index),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Constants.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    } else {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Image.file(
                                File(_images[index - _imageUrls.length].path),
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover),
                          ),
                          if (_isEditing)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () => _deleteImage(index),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Constants.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: _buildInputDecoration('Journal Title'),
                style: _buildTextStyle(),
                enabled: _isEditing,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _buildInputDecoration('Journal Description'),
                style: _buildTextStyle(),
                enabled: _isEditing,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isEditing ? () => _chooseLocation(context) : null,
                child: Text(
                  _selectedLocation == null
                      ? 'Choose Location'
                      : 'Change Location',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              if (_selectedLocation != null) ...[
                SizedBox(height: 16),
                Text(
                  'Selected Location: \n(${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation!,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('selected-location'),
                        position: _selectedLocation!,
                      ),
                    },
                  ),
                ),
              ],
              SizedBox(height: 16),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveJournal,
                  child: _isSaving
                      ? CircularProgressIndicator(
                          color: Constants.primaryColor,
                        )
                      : Text(
                          'Save Journal',
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.highlightColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(88.0),
        ),
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        child: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white),
        backgroundColor: _isEditing
            ? Color.fromRGBO(255, 136, 0, 1)
            : Constants.primaryColor,
      ),
    );
  }
}
