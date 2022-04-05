import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  InfoPageState createState() => new InfoPageState();
}

class InfoPageState extends State<InfoPage> {

  final List<String> listItems = [
    ('Step 1: Choose one or multiple destinations!'),
    ('Step 2: Click on the direction icon to view your route!'),
    ('Step 3: Start navigation by clicking the fourth icon'),
    ('Step 4: Enjoy your journey through London!'),
    ('Extra Features'),
    ('Pick a group size or even manage your journey through our journey planner!'),
    ('Enjoy our most iconic places that will guide you around the city!'),
    ('Create an account in order to save your favourite destinations!'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How to use the app?"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListAppWidget(listItems)
    );
  }
}

//The widget to be tested
class ListAppWidget extends StatefulWidget {
  List<String> listItems = [];
  ListAppWidget(List<String> lst) {
    listItems.clear(); listItems.addAll(lst);
  }

  @override
  ListAppWidgetState createState() => new ListAppWidgetState();
}

class ListAppWidgetState extends State<ListAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        key: Key("myListView"),
        itemCount: widget.listItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(5),
            child: Card(
              shadowColor: Colors.black,
              margin: EdgeInsets.all(7),
              child: Container(
                color: Colors.blue[700],
                height: 120,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(7, 10, 5, 10),
                    child: Text(
                      widget.listItems[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      key:Key("listViewText")
                    ),
                  )
                )
              )
            ),
          );
        }
      )
    );
  }
}
