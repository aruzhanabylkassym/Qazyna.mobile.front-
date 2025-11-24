class ServerMessage {
  final String responseMessage;

  ServerMessage({required this.responseMessage});

  factory ServerMessage.fromJson(Map<String, dynamic> json) =>
      ServerMessage(responseMessage: (json["response_message"] ?? "").toString());
}
