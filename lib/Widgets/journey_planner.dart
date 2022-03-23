import 'package:flutter/material.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class JourneyPlanner extends StatefulWidget {
  const JourneyPlanner({Key? key}) : super(key: key);

  @override
  _JourneyPlannerState createState() => _JourneyPlannerState();
}

class _JourneyPlannerState extends State<JourneyPlanner> {
  late final ApplicationProcesses applicationProcesses;
  PanelController _pc1 = PanelController();
  int _currentValue = 1;

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
                  'Select a group size',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              NumberPicker(
                value: _currentValue,
                minValue: 1,
                maxValue: 10,
                onChanged: (value) => setState(() => _currentValue = value),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,4,0),
                        child: ElevatedButton(
                            onPressed: () {
                              _pc1.close();
                            },
                            child: Text('Cancel')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4,0,8,0),
                        child: ElevatedButton(
                            onPressed: () {
                              // set group size
                              _pc1.close();
                            },
                            child: Text('Apply')),
                      ),
                    ),
                  ],
                ),
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
