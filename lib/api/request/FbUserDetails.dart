// To parse this JSON data, do
//
//     final fbUser = fbUserFromJson(jsonString);

import 'dart:convert';

FbUserDetails fbUserDetailsFromJson(String str) {
  final jsonData = json.decode(str);
  return FbUserDetails.fromJson(jsonData);
}

String fbUserDetailsToJson(FbUserDetails data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class FbUserDetails {
  String name;
  String firstName;
  String lastName;
  String email;
  Picture picture;
  String id;

  FbUserDetails({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.picture,
    this.id,
  });

  factory FbUserDetails.fromJson(Map<String, dynamic> json) =>
      new FbUserDetails(
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        picture: Picture.fromJson(json["picture"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "picture": picture.toJson(),
        "id": id,
      };
}

class Picture {
  Data data;

  Picture({
    this.data,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => new Picture(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  int height;
  bool isSilhouette;
  String url;
  int width;

  Data({
    this.height,
    this.isSilhouette,
    this.url,
    this.width,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        height: json["height"],
        isSilhouette: json["is_silhouette"],
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "is_silhouette": isSilhouette,
        "url": url,
        "width": width,
      };
}
