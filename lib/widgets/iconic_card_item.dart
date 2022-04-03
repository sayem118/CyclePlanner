import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:cycle_planner/processes/application_processes.dart';




 class CardItem extends StatefulWidget {
  // var _place;
  // PlaceDetails(_place);
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
    required this.placeInfo
   }) : super(// coverage:ignore-line
      key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}


class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    return Container(
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
                          subtitle: Container(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Text(
                                widget.itemInfo,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left ,
                              )
                          ),

                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                            icon: const Icon(Icons.add_location_alt),
                            onPressed: () {
                              applicationProcesses.toggleMarker(widget.placeId);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                              ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("users-favourite-places").doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("places").where("name",isEqualTo: widget.itemTitle).snapshots(), builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.data == null){
                              return Text("");
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                onPressed: () => snapshot.data.docs.length == 0? addToFavourite():print ("Already added"),
                                icon: snapshot.data.docs.length == 0? Icon(
                                  Icons.favorite_outline,
                                  size: 20.0,
                                  color: Colors.red[900],
                                ): Icon(
                        Icons.favorite,
                        ),

                              ),
                            );
                      }),
                     
                  ],
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

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-favourite-places");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("iconic-places")
        .doc()
        .set({
      "name": widget.itemTitle,
      "images": widget.imageInfo,
      "Id": widget.placeId,
      "info": widget.itemInfo,
    }).then((value) => print("Added to favourite"));
  }
}