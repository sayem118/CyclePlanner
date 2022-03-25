import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';


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
                String imageInfo = snapshot.data!.docs[index]['image'];

                return CardItem(itemTitle: itemTitle, itemInfo: itemInfo, imageInfo: imageInfo,);
          });
          },
        ),
    );
  }
}


class CardItem extends StatefulWidget {
    final String itemTitle;
    final String itemInfo;
    final String imageInfo;

  const CardItem({Key? key, required this.itemTitle, required this.itemInfo, required this.imageInfo}) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}


class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTileCard(
        //background: Image.network(widget.imageInfo),
        title: Text(widget.itemTitle,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.grey[370],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(widget.itemInfo,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left
              ),

            trailing:  FavoriteButton(
              isFavorite: false, valueChanged: (_isFavorite){
                if (kDebugMode) {
                  print('Is Favorite : $_isFavorite');
                }
            },
            ),
            ),
          ),
        ],
      ),
    );
  }
}

