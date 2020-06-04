class ChatSettings {
  bool requestedChat;
  bool messageAllowed;
  final String senderID;
  final String receiverID;
  bool blocked;
  String blockedBy;
  bool primaryChat;

  ChatSettings({
    this.requestedChat,
    this.messageAllowed,
    this.senderID,
    this.receiverID,
    this.blocked,
    this.blockedBy,
    this.primaryChat,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) {
    return ChatSettings(
      requestedChat: json['requestedChat'],
      messageAllowed: json['messageAllowed'],
      senderID: json['senderID'],
      receiverID: json['receiverID'],
      blocked: json['blocked'],
      blockedBy: json['blockedBy'],
      primaryChat: json['primaryChat'],
    );
  }
}
