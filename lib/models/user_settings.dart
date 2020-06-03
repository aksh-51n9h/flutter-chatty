class UserSettings {
  String fullname;
  String username;
  String bio;

  UserSettings({this.fullname, this.username, this.bio});

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      fullname: json['fullname'],
      username: json['username'],
      bio: json['bio'],
    );
  }
}