import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


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
      appBar: AppBar(title: const Text("Iconic Places"),),
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
                return CardItem(itemTitle: itemTitle);
          });
          },
        ),
    );
  }
}


class CardItem extends StatefulWidget {
    final String itemTitle;
  const CardItem({Key? key, required this.itemTitle}) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: ListTile(
        title: Text(widget.itemTitle),
      trailing:  FavoriteButton(
        isFavorite: false, valueChanged: (_isFavorite){
          print('Is Favorite : $_isFavorite');
      },
      ),
      ),
    );
  }
}

