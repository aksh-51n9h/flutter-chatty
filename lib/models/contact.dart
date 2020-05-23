class Contact {
  final String receiverID;
  final bool blocked;
  final String blockedBy;
  final String fullname;
  final String username;

  Contact({
    this.receiverID,
    this.blocked,
    this.blockedBy,
    this.fullname,
    this.username,
  });

  factory Contact.fromJson(Map<String, dynamic> json){
    return Contact(
      receiverID: json['receiverID'],
      blocked: json['blocked'],
      blockedBy: json['blockedBy'],
      fullname: json['fullname'],
      username: json['username']
    );
  }
}
