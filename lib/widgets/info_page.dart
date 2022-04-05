import 'package:flutter/material.dart';


class InfoPage extends StatefulWidget {
  String name = "";
  d(nme){
    name = nme;
    IconData icon;
  }
  InfoPageState createState() => new InfoPageState();
}


class InfoPageState extends State<InfoPage> {

  final List<String> listItems = [
  ('Step 1: Choose one or multiple destinations!'),
  ('Step 2: Click on the direction icon to view your route!'),
  ('Step 3: Start navigation by clicking the fourth icon'),
  ('Step 4: Enjoy your journey through London! '),
  ('Extra Features'),
  ('Pick a group size! or even manage your journey through our journey planner!'),
  ('Enjoy our most iconic places that will guide you around the city! '),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Info Page"),
          backgroundColor: Colors.blueGrey,
        ),
            body: Column(children: <Widget>[
              Text(
             "Guide",
             style: TextStyle(
                 fontSize:50,
                color: Colors.blueAccent,
               fontWeight: FontWeight.w500,
             )
              ),
              ListAppWidget(listItems),
            ],
            )
        );
  }
}

//The widget to be tested
class ListAppWidget extends StatefulWidget {
  List<String> listItems =[];
  ListAppWidget(List<String> lst){
    listItems.clear(); listItems.addAll(lst);
  }

  @override
  ListAppWidgetState createState() => new ListAppWidgetState();
}

class ListAppWidgetState extends State<ListAppWidget> {
  @override
  Widget build(BuildContext context) {
    return(
        Container(
            width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height/2,
            padding: EdgeInsets.only(left:10,right:10,top:20,bottom:20),
            child: ListView.builder(
                key:Key("myListView"),
                itemCount: widget.listItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(child:Container(
                      height:100,
                      child:Center(child:Text( widget.listItems[index], key:Key("listViewText"))))
                  );
                }
            )
        )
    );
  }
}








