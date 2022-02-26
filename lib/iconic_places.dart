import 'package:flutter/material.dart';


class IconicScreen extends StatefulWidget {
  const IconicScreen({Key? key}) : super(key: key);

  @override
  _IconicScreenState createState() => _IconicScreenState();
}

class _IconicScreenState extends State<IconicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text("Iconic Places"),),
    );
  }
}
