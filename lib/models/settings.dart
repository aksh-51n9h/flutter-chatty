class Settings{
  String fullname;
  String username;
  String bio;

  Settings({this.fullname, this.username, this.bio});

  factory Settings.fromJson(Map<String, dynamic> json){
    return Settings(
      fullname: json['fullname'],
      username: json['username'],
      bio: json['bio'],
    );
  }
   
}