import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GroupSize extends StatefulWidget {
  const GroupSize({Key? key}) : super(key: key);

  @override
  _GroupSizeState createState() => _GroupSizeState();
}

class _GroupSizeState extends State<GroupSize> {
  int? _currentValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          value: _currentValue!,
          minValue: 1,
          maxValue: 8,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
        Text('Current value: $_currentValue'),
      ],
    );
  }
}