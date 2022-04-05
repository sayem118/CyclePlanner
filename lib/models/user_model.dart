/// Create a [UserModel] using user information
/// that is retrieved from Firestore database.

class UserModel {
  
  // Class Variables
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  // Class constructor
  UserModel({this.uid, this.email, this.firstName, this.secondName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}