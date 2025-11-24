class LinkRequest {
  final String ownerLogin;
  final String consumerLogin;
  LinkRequest({required this.ownerLogin, required this.consumerLogin});
  Map<String, dynamic> toJson() => {"owner_login": ownerLogin, "cons_login": consumerLogin};
}

class LoginContainer {
  final String userLogin;
  LoginContainer({required this.userLogin});
  Map<String, dynamic> toJson() => {"user_login": userLogin};
}

class Link {
  final String supplierLogin;
  final String consumerLogin;
  final String linkStatus;

  Link({
    required this.supplierLogin,
    required this.consumerLogin,
    required this.linkStatus,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        supplierLogin: json["supplier_login"],
        consumerLogin: json["consumer_login"],
        linkStatus: json["link_status"] ?? "Unknown",
      );
}
