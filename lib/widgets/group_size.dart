import 'package:flutter/material.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';

class GroupSize extends StatefulWidget {
  const GroupSize({Key? key}) : super(key: key);

  @override
  _GroupSizeState createState() => _GroupSizeState();
}

class _GroupSizeState extends State<GroupSize> {
  late final ApplicationProcesses applicationProcesses;

  @override
  void initState(){
    applicationProcesses = Provider.of<ApplicationProcesses>(context, listen:false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journey'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                'My stops',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ReorderableListView(
              children: _getListItems(),
              // The reorder function
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  final element = applicationProcesses.markers.removeAt(oldIndex);

                  applicationProcesses.markers.insert(newIndex, element);
                });
              }
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getListItems() => applicationProcesses.markers
    .asMap()
    .map((i, item) => MapEntry(i, _buildTenableListTile(i)))
    .values
    .toList();

  Widget _buildTenableListTile(int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          applicationProcesses.removeMarker(index);
        });
      },
      background: Container(color: Colors.red),
      child: ListTile(
        key: ValueKey(index),
        title: Text(
          applicationProcesses.markers[index].markerId.value,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        onTap: () {},
        leading: Icon(Icons.location_pin),
        trailing: Icon(Icons.menu),
      ),
    );
  }
}
