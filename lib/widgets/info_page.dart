import 'package:flutter/material.dart';


class InfoPage extends StatefulWidget {
  @override
  String name = "";
  d(nme){
    name = nme;
  }
  InfoPageState createState() => new InfoPageState();
}


class InfoPageState extends State<InfoPage> {
  // List<String> listItems =[
  //   ("Step 1 : take ammars dick"), ("Step 2: drag it along asscrack"), ("Step: 3 shove it back in his ass")
  // ];

  final List<String> steps = <String>[
    'Step 1: Choose your destination through search ',
    'Step 2: View your guided route ',
    'Step 3: Find your waypoitns ',
    'Step 4: ddd ',
    'Step: 5 dddd'
  ];
  final List<IconData> icons = <IconData>[
    Icons.search,
    Icons.search,
    Icons.favorite,
    Icons.favorite,
    Icons.search
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Info Page"),
          backgroundColor: Colors.redAccent,
        ),
            body: Column(children: <Widget>[
              Text("Guide, "
                  , style: TextStyle(fontSize:20)),
              ListAppWidget(steps),
            ],)
        );

  }

}

//The widget to be tested
class ListAppWidget extends StatefulWidget {
  List<String> steps =[];
  List<IconData> icons =[];
  ListAppWidget(List<String> lst){
    steps.clear(); steps.addAll(lst);
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
                itemCount: widget.steps.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon (widget.icons[index]),
                  Card(
                  child:Container(
                  height:100,
                  child:Center(child:Text( widget.steps[index], key:Key("listViewText")),))


                  )
                    ],
                  );

                  //   Card(
                  //     child:Container(
                  //     height:100,
                  //     child:Center(child:Text( widget.steps[index], key:Key("listViewText")),))
                  //
                  //
                  // );
                })
        )
    );
  }
}

    //     children: <Widget>[
    //     Icon(icons[index]['icon']),
    // SizedBox(width: 20.0),
    // Text(_categories[index]['name']),
    // ],
    // );





