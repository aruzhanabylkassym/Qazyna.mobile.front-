class UserCredentials {
  int? userId;
  String userLogin;
  String? userPassHash;
  String firstName;
  String lastName;
  String accType; // "consumer" or "supplier"
  String orgType;
  String orgName;

  UserCredentials({
    this.userId,
    required this.userLogin,
    this.userPassHash,
    required this.firstName,
    required this.lastName,
    required this.accType,
    required this.orgType,
    required this.orgName,
  });

  Map<String, dynamic> toRegisterJson() => {
        "user_login": userLogin,
        "first_name": firstName,
        "last_name": lastName,
        "acc_type": accType,
        "org_type": orgType,
        "org_name": orgName,
      };

  Map<String, dynamic> toLoginJson() => {
        "user_login": userLogin,
      };

  factory UserCredentials.fromSupplierOwnerRow(Map<String, dynamic> json) => UserCredentials(
        userId: json["user_id"] ?? json["supp_id"],
        userLogin: json["user_login"] ?? json["supp_login"],
        userPassHash: json["user_pass"] ?? json["supp_pass"],
        firstName: json["first_name"] ?? json["supp_first_name"],
        lastName: json["last_name"] ?? json["supp_last_name"],
        accType: json["acc_type"] ?? json["supp_role"], // Owner
        orgType: json["org_type"] ?? json["supp_org_type"],
        orgName: json["org_name"] ?? json["supp_org_name"],
      );
}
