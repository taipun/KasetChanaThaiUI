class User {
  String userId;
  String userEmail;
  String userPassword;
  String userName;
  String userPictureurl;
  String userRegion;
  bool userIsDeleted;

  User(
      {this.userId,
      this.userEmail,
      this.userPassword,
      this.userName,
      this.userPictureurl,
      this.userRegion,
      this.userIsDeleted});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return User(
          userId: parsedJson['_id'],
          userEmail: parsedJson['email'],
          userPassword: parsedJson['password'],
          userName: parsedJson['name'],
          userPictureurl: parsedJson['pictureurl'],
          userRegion: parsedJson['region'],
          userIsDeleted: parsedJson['isDeleted']);
    } catch (ex) {
      print('UserModel User ====> $ex');
      throw ('factory User.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': userId,
        'email': userEmail,
        'password': userPassword,
        'name': userName,
        'pictureurl': userPictureurl,
        'region': userRegion,
        'isDeleted': userIsDeleted,
      };
}
