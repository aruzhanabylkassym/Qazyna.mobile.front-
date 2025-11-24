class GetPhotos {
  final String whoUploaded;
  final String whoRequested;

  GetPhotos({required this.whoUploaded, required this.whoRequested});

  Map<String, dynamic> toJson() => {
        "who_uploaded": whoUploaded,
        "who_requested": whoRequested,
      };
}

class PhotoItem {
  final String userLogin;
  final String photoUrl;

  PhotoItem({required this.userLogin, required this.photoUrl});

  factory PhotoItem.fromJson(Map<String, dynamic> json) =>
      PhotoItem(userLogin: json["user_login"], photoUrl: json["photo_url"]);
}
