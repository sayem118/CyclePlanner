/// Class description:
/// This class creates a group size
/// for users who would like to add
/// more than one person in their bicycle journey.

class Groups {
  // Class variable
  int groupSize;

  // Class constructor
  Groups({required this.groupSize});

  // Return number of people in a group
  int getGroupSize() {
    return groupSize;
  }

  // Set number of people in a group
  void setGroupSize(int num) {
    groupSize = num;
  }
}