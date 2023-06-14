class UserDataModel {
  UserDataModel(
      {required this.id,
      required this.name,
      required this.email,
      // this.password,
      // this.image,
      // this.improve,
      // this.notifyTime,
      // this.notifyDay,
      this.verificationCode,
      // this.verifiedAt,
      // this.apiAuthToken,
      // this.andDeviceId,
      // this.iosDeviceId,
      // this.status,
      // this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.gmail
      // this.bearerToken,
      });

  int id;
  String name;
  String email;
  String? gmail;
  // String? password;
  // String? image;
  // String? improve;
  // String? notifyTime;
  // String? notifyDay;
  String? verificationCode;
  // DateTime? verifiedAt;
  // String? apiAuthToken;
  // String? andDeviceId;
  // String? iosDeviceId;
  // dynamic status;
  // String? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  // String? bearerToken;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        gmail: json["gmail"],
        // password: json["password"],
        // image: json["image"],
        // improve: json["improve"],
        // notifyTime: json["notify_time"],
        // notifyDay: json["notify_day"],
        verificationCode: json["verification_code"],
        // verifiedAt: DateTime.parse(json["verified_at"]),
        // apiAuthToken: json["api_auth_token"],
        // andDeviceId: json["and_device_id"],
        // iosDeviceId: json["ios_device_id"],
        // status: json["status"],
        // deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        // bearerToken: json["bearer_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "gmail": gmail,
        // "password": password,
        // "image": image,
        // "improve": improve,
        // "notify_time": notifyTime,
        // "notify_day": notifyDay,
        "verification_code": verificationCode,
        // "verified_at": verifiedAt?.toIso8601String(),
        // "api_auth_token": apiAuthToken,
        // "and_device_id": andDeviceId,
        // "ios_device_id": iosDeviceId,
        // "status": status,
        // "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        // "bearer_token": bearerToken,
      };
}
