import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String phoneNo;

  UserModel(this.name, this.email, this.password, this.phoneNo);

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        email = snapshot['email'],
        password = snapshot['password'],
        phoneNo = snapshot['phoneNo'];

  Map<String, dynamic> toJson() =>
      {"name": name, "email": email, "password": password, "phoneNo": phoneNo};
}
