// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

List<Employee> employeeFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
    int? id;
    String? password;
    DateTime? lastLogin;
    bool? isSuperuser;
    String? type;
    String? username;
    String? email;
    String? phoneNumber;
    String? bio;
    dynamic photoUrl;
    bool? isStaff;
    bool? isActive;
    int? company;
    List<dynamic>? groups;
    List<dynamic>? userPermissions;

    Employee({
        this.id,
        this.password,
        this.lastLogin,
        this.isSuperuser,
        this.type,
        this.username,
        this.email,
        this.phoneNumber,
        this.bio,
        this.photoUrl,
        this.isStaff,
        this.isActive,
        this.company,
        this.groups,
        this.userPermissions,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        password: json["password"],
        lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
        isSuperuser: json["is_superuser"],
        type: json["type"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        bio: json["bio"],
        photoUrl: json["photoUrl"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        company: json["company"],
        groups: json["groups"] == null ? [] : List<dynamic>.from(json["groups"]!.map((x) => x)),
        userPermissions: json["user_permissions"] == null ? [] : List<dynamic>.from(json["user_permissions"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "last_login": lastLogin?.toIso8601String(),
        "is_superuser": isSuperuser,
        "type": type,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "bio": bio,
        "photoUrl": photoUrl,
        "is_staff": isStaff,
        "is_active": isActive,
        "company": company,
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
        "user_permissions": userPermissions == null ? [] : List<dynamic>.from(userPermissions!.map((x) => x)),
    };
}
