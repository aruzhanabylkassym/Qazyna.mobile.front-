class RequestIssue {
  final String consumerLogin;
  final String supplierLogin;
  final String issueTopic;
  final String issueDescription;

  RequestIssue({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.issueTopic,
    required this.issueDescription,
  });

  Map<String, dynamic> toJson() => {
        "consumer_login": consumerLogin,
        "supplier_login": supplierLogin,
        "issue_topic": issueTopic,
        "issue_description": issueDescription,
      };
}

class Issue {
  final String consumerLogin;
  final String supplierLogin;
  final String issueTopic;
  final String issueDescription;
  final String solutionResponse;
  final String solutionComments;
  final bool isResolved;

  Issue({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.issueTopic,
    required this.issueDescription,
    required this.solutionResponse,
    required this.solutionComments,
    required this.isResolved,
  });

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        consumerLogin: json["consumer_login"],
        supplierLogin: json["supplier_login"],
        issueTopic: json["issue_topic"],
        issueDescription: json["issue_description"],
        solutionResponse: json["solution_response"] ?? "",
        solutionComments: json["solution_comments"] ?? "",
        isResolved: json["is_resolved"] ?? false,
      );
}
