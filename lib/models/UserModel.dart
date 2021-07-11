
class UserModel {
  final String uId;
  final String name;
  final String email;
  final String password;
  final String phoneNo;
  final String profileImage;

  UserModel(this.uId, this.name, this.email, this.password, this.phoneNo,
      this.profileImage);

  // UserModel.fromSnapshot(DocumentSnapshot snapshot)
  //     : uId = snapshot['uId'],
  //       name = snapshot['name'],
  //       email = snapshot['email'],
  //       password = snapshot['password'],
  //       phoneNo = snapshot['phoneNo'],
  //       profileImage = snapshot['profileImage'];

  Map<String, dynamic> toJson() => {
        "uId": uId,
        "name": name,
        "email": email,
        "password": password,
        "phoneNo": phoneNo,
        "profileImage": profileImage
      };
}
