import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? valid;
  User? user;

  UserModel({
    this.valid,
    this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        valid: json["valid"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "valid": valid,
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? email;
  String? username;
  String? role;
  String? directorate;
  Hospital? hospital;
  List<Permission>? permissions;
  int? iat;
  int? exp;
  District? district;

  User(
      {this.id,
      this.email,
      this.username,
      this.role,
      this.directorate,
      this.hospital,
      this.permissions,
      this.iat,
      this.exp,
      this.district});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        role: json["role"],
        directorate: json["directorate"],
        district: json["district"] == null
            ? null
            : District.fromJson(json["district"]),
        hospital: json["hospital"] == null
            ? null
            : Hospital.fromJson(json["hospital"]),
        permissions: json["permissions"] == null
            ? []
            : List<Permission>.from(
                json["permissions"]!.map((x) => Permission.fromJson(x))),
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "role": role,
        "directorate": directorate,
        "hospital": hospital?.toJson(),
        "district": district?.toJson(),
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
        "iat": iat,
        "exp": exp,
      };
}

class Hospital {
  int? hospitalid;
  String? districtname;
  String? hospitalname;
  int? mainhospitaltype;
  String? hospitaltype;
  String? hospitalname108;
  String? typeOfHospital;
  String? institutionCode;
  int? statecode;
  int? districtId;

  Hospital({
    this.hospitalid,
    this.districtname,
    this.hospitalname,
    this.mainhospitaltype,
    this.hospitaltype,
    this.hospitalname108,
    this.typeOfHospital,
    this.institutionCode,
    this.statecode,
    this.districtId,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        hospitalid: json["hospitalid"],
        districtname: json["districtname"],
        hospitalname: json["hospitalname"],
        mainhospitaltype: json["mainhospitaltype"],
        hospitaltype: json["hospitaltype"],
        hospitalname108: json["hospitalname108"],
        typeOfHospital: json["type_of_hospital"],
        institutionCode: json["institution_code"],
        statecode: json["statecode"],
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "hospitalid": hospitalid,
        "districtname": districtname,
        "hospitalname": hospitalname,
        "mainhospitaltype": mainhospitaltype,
        "hospitaltype": hospitaltype,
        "hospitalname108": hospitalname108,
        "type_of_hospital": typeOfHospital,
        "institution_code": institutionCode,
        "statecode": statecode,
        "district_id": districtId,
      };
}

class Permission {
  String? page;
  String? access;

  Permission({
    this.page,
    this.access,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        page: json["page"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "access": access,
      };
}

class District {
  int? id;
  String? name;
  String? code;
  bool? isEnabled;

  District({
    this.id,
    this.name,
    this.code,
    this.isEnabled,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "is_enabled": isEnabled,
      };
}
