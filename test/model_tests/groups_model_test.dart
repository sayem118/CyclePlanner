//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/groups.dart';

void main() {
  test('Groups constructor sets attributes', () {
    final mockGroup = Groups(groupSize: 3);
    //ensure the number 3 is set
    expect(mockGroup.groupSize, 3);
  });

  test('getGroupSize() returns an integer', () {
    final mockGroup = Groups(groupSize: 4);
    //ensure the number 4 is returned
    expect(mockGroup.getGroupSize(), 4);
  });

  test('setGroupSize works correctly', () {
    final mockGroup = Groups(groupSize: 4);
    mockGroup.setGroupSize(2);
    //ensure the number 2 is set
    expect(mockGroup.groupSize, 2);
  });
}