//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/user_model.dart';

void main() {
  test('User Model constructor sets attributes', () {
    final mockUserModel = UserModel(uid: "Test",
        email: "test@test.com",
        firstName: "Test",
        secondName: "Test");
    //ensure the attributes are set
    expect(mockUserModel.uid, "Test");
    expect(mockUserModel.email, "test@test.com");
    expect(mockUserModel.firstName, "Test");
    expect(mockUserModel.secondName, "Test");
  });

  test('Testing User Model fromMap method', () {

    //creating a test JSON and feeding it in
    Map<dynamic, dynamic> mockUserModelJSON = {'uid':  "Test", "email": "test@test.com",
      "firstName": "Test", "secondName": "Test"};
    final mockUserModel = UserModel.fromMap(mockUserModelJSON);

    //ensure the attributes are set
    expect(mockUserModel.uid, "Test");
    expect(mockUserModel.email, "test@test.com");
    expect(mockUserModel.firstName, "Test");
    expect(mockUserModel.secondName, "Test");
  });

  test('Testing User Model toMap method', () {

    //creating a test JSON and feeding it in
    final mockUserModel = UserModel(uid: "Test",
        email: "test@test.com",
        firstName: "Test",
        secondName: "Test");
    Map<dynamic, dynamic> mockUserModelMap = mockUserModel.toMap();

    //ensure the attributes are set
    expect(mockUserModel.uid, "Test");
    expect(mockUserModel.email, "test@test.com");
    expect(mockUserModel.firstName, "Test");
    expect(mockUserModel.secondName, "Test");
  });
}