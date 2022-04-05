import 'package:flutter/material.dart';
import 'fetchData.dart';

class SavedPlaces extends StatefulWidget {
  const SavedPlaces({Key? key}) : super(key: key);

  @override
  _SavedPlacesState createState() => _SavedPlacesState();
  }

  class _SavedPlacesState extends State<SavedPlaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved places"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: fetchData("users-favourite-places"),
      ),
    );
  }
}