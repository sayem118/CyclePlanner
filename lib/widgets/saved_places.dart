// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'iconic_card_item.dart';
//
//
//
// class SavedPlaces extends StatefulWidget {
//   const SavedPlaces({Key? key,}) : super(key: key);
//
//
//   @override
//   _SavedScreenState createState() => _SavedScreenState();
// }
//
// class _SavedScreenState extends State<SavedPlaces> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   import 'package:cloud_firestore/cloud_firestore.dart';
//   import 'package:firebase_auth/firebase_auth.dart';
//   import 'package:flutter/cupertino.dart';
//   import 'package:flutter/material.dart';
//   import 'package:flutter_ecommerce/widgets/fetchProducts.dart';

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
  body: SafeArea(
  child: fetchData("users-favourite-places"),
  ),
  );
  }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Favoured places"),
  //       backgroundColor: Colors.redAccent,
  //     ),
  //
  //     body: StreamBuilder(
  //       stream: firestore.collection("users-favourite-places").doc(FirebaseAuth.instance.currentUser!.email).collection("iconic-places").snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
  //         if(snapshot.hasError) {
  //           return const Center(
  //             child: Text("Something bad!"),
  //           );
  //         }
  //   return ListView.builder(
  //   itemCount: snapshot.data!.docs.length,
  //   itemBuilder: (context, index) {
  //   String itemTitle = snapshot.data!.docs[index]['name'] ;
  //   String itemInfo = snapshot.data!.docs[index]['address'];
  //   String placeInfo = snapshot.data!.docs[index]['place_info'];
  //   String imageInfo = snapshot.data!.docs[index]['image'];
  //   String placeId = snapshot.data!.docs[index]['place_id'];
  //
  //   return CardItem(itemTitle: itemTitle, itemInfo: itemInfo, imageInfo: imageInfo, placeId: placeId, placeInfo: placeInfo );
  //   });
  //   },
  //
  //     ),
  //   );
  // }


//}



