
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fetchData.dart';

class SavedPlaces extends StatefulWidget {
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
//
//
//
