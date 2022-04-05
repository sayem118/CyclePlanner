import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget fetchData (String collectionName) {
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
            child: Text(
              "No saved places",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
      }
      return ListView.builder(
        itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
        itemBuilder: (_, index) {
          DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
          return Container(
            padding: EdgeInsets.all(6),
            child: Card(
              elevation: 7,
              child: Container(
                height: 80,
                child: ListTile(
                  leading: Text(
                    _documentSnapshot['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  title: Text(
                    _documentSnapshot['place_info'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17
                    )
                  ),
                  horizontalTitleGap: 24,
                ),
              ),
            ),
          );
        }
      );
    },
  );
}