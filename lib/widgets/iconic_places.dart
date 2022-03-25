import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:provider/provider.dart';
import 'package:cycle_planner/processes/application_processes.dart';


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

class CardItem extends StatefulWidget {
    final String itemTitle;
    final String itemInfo;
    final String imageInfo;
    final String placeId;
    final String placeInfo;

  const CardItem({Key? key,
    required this.itemTitle,
    required this.itemInfo,
    required this.imageInfo,
    required this.placeId,
    required this.placeInfo}) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}


class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 20,
          shadowColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children:  <Widget>[
              Padding(padding: const EdgeInsets.all(8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 245.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.imageInfo))),
                ),
              ),
              ExpansionTileCard(
                borderRadius: BorderRadius.circular(5),
                title: Text(widget.itemTitle,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
                children:  <Widget>[
                  Padding(padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(
                        widget.placeInfo,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  )
                ],
              )
            ]
          )
        ),
      );
  }
}

