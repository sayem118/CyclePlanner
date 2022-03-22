import 'package:flutter/material.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GroupSize extends StatefulWidget {
  const GroupSize({Key? key}) : super(key: key);

  @override
  _GroupSizeState createState() => _GroupSizeState();
}

class _GroupSizeState extends State<GroupSize> {
  late final ApplicationProcesses applicationProcesses;
  int _currentValue = 1;
  PanelController _pc1 = PanelController();

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
      body: SlidingUpPanel(
        controller: _pc1,
        panel: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: Text(
                  'Group size',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              NumberPicker(
                value: _currentValue,
                minValue: 1,
                maxValue: 10,
                onChanged: (value) => setState(() => _currentValue = value),
              ),
            ],
          ),
        ),
        minHeight: 0,
        maxHeight: 300,
        backdropEnabled: true,
        backdropColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.group_add),
                      onPressed: () {
                        _pc1.open();
                      },
                    label: Text('Group size: $_currentValue'),
                      ),
                ],
              ),
            ),
            SizedBox(
              height: 600,
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
