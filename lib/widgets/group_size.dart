import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GroupSize extends StatefulWidget {
  const GroupSize({Key? key}) : super(key: key);

  @override
  _GroupSizeState createState() => _GroupSizeState();
}

class _GroupSizeState extends State<GroupSize> {
  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration( // Comment decoration for transluscent effect
                  border: Border.all(color: Colors.black)
                ),
                child: NumberPicker(
                  value: _currentValue,
                  minValue: 1,
                  maxValue: 8,
                  onChanged: (value) => setState(() => _currentValue = value),
                  haptics: true,
                  itemHeight: 90.0,
                  itemWidth: 150.0,
                  textStyle: const TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Current value: $_currentValue',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}