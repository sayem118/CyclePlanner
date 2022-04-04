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
  List<String> listItems =[];
  int n = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Info Page"),
          backgroundColor: Colors.redAccent,
        ),
            body: Column(children: <Widget>[
              Text("Hello, "
                  , style: TextStyle(fontSize:20)),
              ListAppWidget(listItems),
              RaisedButton(
                onPressed: () {n +=1 ;
                listItems.add("item:" + n.toString());
                setState(() {});
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.lightBlueAccent)
                ),
                child: Text(
                    'Add',
                    style: TextStyle(fontSize: 15,color: Colors.white)
                ),
              )

            ],)
        );

  }

}


