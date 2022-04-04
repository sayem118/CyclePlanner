import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget fetchData (String collectionName){
  return StreamBuilder(
    stream: FirebaseFirestore.instance
      .collection(collectionName)
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("iconic-places")
      .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData){
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No saved places"),
          );
        }
      }


      return ListView.builder(
        itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
        itemBuilder: (_, index) {
          DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
          return Card(
            elevation: 5,
            child: ListTile(
              leading: Text(_documentSnapshot['name']),
              title: Text(_documentSnapshot['place_info']),
            ),

          );
        }
      );
    },
  );
}