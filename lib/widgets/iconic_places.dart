import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'iconic_card_item.dart';



class IconicScreen extends StatefulWidget {
   const IconicScreen({Key? key,}) : super(key: key);


  @override
  _IconicScreenState createState() => _IconicScreenState();
}

class _IconicScreenState extends State<IconicScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iconic Places"),
        backgroundColor: Colors.redAccent,
      ),

    body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("iconic-places").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return const Text('Loading ...');
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String itemTitle = snapshot.data!.docs[index]['name'] ;
                String itemInfo = snapshot.data!.docs[index]['address'];
                String placeInfo = snapshot.data!.docs[index]['place_info'];
                String imageInfo = snapshot.data!.docs[index]['image'];
                String placeId = snapshot.data!.docs[index]['place_id'];

                return CardItem(itemTitle: itemTitle, itemInfo: itemInfo, imageInfo: imageInfo, placeId: placeId, placeInfo: placeInfo );
          });
          },
        ),
    );
  }


}



