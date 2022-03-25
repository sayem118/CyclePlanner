import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:cycle_planner/processes/application_processes.dart';

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
                          trailing: IconButton(
                            icon: const Icon(Icons.add_location_alt),
                            onPressed: () {
                              applicationProcesses.toggleMarker(widget.placeId);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
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