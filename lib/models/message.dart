class SendMessage {
  final String consumerLogin;
  final String supplierLogin;
  final String senderLogin;
  final String userMessage;

  SendMessage({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.senderLogin,
    required this.userMessage,
  });

  Map<String, dynamic> toJson() => {
        "consumer_login": consumerLogin,
        "supplier_login": supplierLogin,
        "sender_login": senderLogin,
        "user_message": userMessage,
      };
}

class GetMessage {
  final String consumerLogin;
  final String supplierLogin;
  final String loadingUser;

  GetMessage({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.loadingUser,
  });

  Map<String, dynamic> toJson() => {
        "consumer_login": consumerLogin,
        "supplier_login": supplierLogin,
        "loading_user": loadingUser,
      };
}

class Message {
  final String consumerLogin;
  final String supplierLogin;
  final String senderLogin;
  final String userMessage;

  Message({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.senderLogin,
    required this.userMessage,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        consumerLogin: json["consumer_login"],
        supplierLogin: json["supplier_login"],
        senderLogin: json["sender_login"],
        userMessage: json["user_message"],
      );
}
