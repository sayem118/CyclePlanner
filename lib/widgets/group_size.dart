import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GroupSize extends StatefulWidget {
  const GroupSize({Key? key}) : super(key: key);

  @override
  _GroupSizeState createState() => _GroupSizeState();
}

class _GroupSizeState extends State<GroupSize> {
  int _currentValue = 1;
  final List<String> _products = [];
  late List<Widget> _test =[];

  @override
  void initState(){
    for(int i = 0; i<20; i++){
      _products.add("location " + i.toString());
    }
    _test = _getListItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journey'),
      ),
      body: ReorderableListView(
          children: _getListItems(),
          // The reorder function
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex = newIndex - 1;
              }
              final element = _products.removeAt(oldIndex);

              _products.insert(newIndex, element);
            });
          }),

    );
  }
  List<Widget> _getListItems() => _products.asMap().map((i, item) => MapEntry(i, _buildTenableListTile(i))).values.toList();



  Widget _buildTenableListTile(int index) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            _products.removeAt(index);
          });
        },
        background: Container(color: Colors.red),
        child: ListTile(
          key: ValueKey(index),
          title: Text(
            _products[index],
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
        ),
      );
    }
  }



