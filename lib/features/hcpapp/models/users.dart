import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  const Users(
      {required this.active,
      required this.genId,
      required this.email,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.fullName,
      required this.displayName,
      required this.roles,
      required this.fcmToken,
      required this.fcmTokens,
      required this.devices,
      required this.branchIds,
      required this.branchNames,
      required this.ownerId,
      required this.userId,
      required this.password,
      this.loginCounter,
      this.lastLoginDate});
  final bool active;
  final int genId;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String displayName;
  final List<dynamic> roles;
  final String fcmToken;
  final List<dynamic> fcmTokens;
  final List<String> devices;
  final List<dynamic> branchIds;
  final List<dynamic> branchNames;
  final String ownerId;
  final int userId;
  final String password;
  final int? loginCounter;
  final Timestamp? lastLoginDate;

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "genId": genId,
      "email": email,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "fullName": fullName,
      "displayName": displayName,
      "roles": roles,
      'fcmToken': fcmToken,
      "fcmTokens": fcmTokens,
      "devices": devices,
      "branchIds": branchIds,
      "branchNames": branchNames,
      "ownerId": ownerId,
      "userId": userId,
      'password': password,
      'loginCounter': loginCounter,
      'lastLoginDate': lastLoginDate
    };
  }
}
// class Users {
//   const Users(
//       {required this.active,
//       required this.genId,
//       required this.email,
//       required this.username,
//       required this.firstName,
//       required this.lastName,
//       required this.fullName,
//       required this.displayName,
//       required this.roles,
//       required this.fcmToken,
//       required this.fcmTokens,
//       required this.branchIds,
//       required this.branchNames,
//       required this.ownerId,
//       required this.userId,
//       required this.password,
//       this.loginCounter});
//   final bool active;
//   final int genId;
//   final String email;
//   final String username;
//   final String firstName;
//   final String lastName;
//   final String fullName;
//   final String displayName;
//   final List<String> roles;
//   final String fcmToken;
//   final List<Map<String, dynamic>> fcmTokens;
//   final List<int> branchIds;
//   final List<String> branchNames;
//   final String ownerId;
//   final int userId;
//   final String password;
//   final int? loginCounter;
//
//   Map<String, dynamic> toMap() {
//     return {
//       "active": active,
//       "genId": genId,
//       "email": email,
//       "username": username,
//       "firstName": firstName,
//       "lastName": lastName,
//       "fullName": fullName,
//       "displayName": displayName,
//       "roles": roles,
//       "fcmToken": fcmToken,
//       "fcmTokens": fcmTokens,
//       "branchIds": branchIds,
//       "branchNames": branchNames,
//       "ownerId": ownerId,
//       "userId": userId,
//       'password': password,
//       'loginCounter': loginCounter
//     };
//   }
// }
// //   UserModels.secondary();
// //
// //   factory UserModels.fromJson(Map<String, dynamic> json) =>
// //       UserModels(
// //           id: json['id'],
// //           email: json['email'],
// //           username: json['username'],
// //           firstName: json['firstName'],
// //           lastName: json['lastName'],
// //           displayName: json['displayName'],
// //           role: json['role'],
// //           fcmToken: json['fcmToken'],
// //           isClient: json['isClient'],
// //           isHCP: json['isHCP'],
// //           isBranch: json['isBranch'],
// //           isCMS: json['isCms']
// //       );
// //
// //
// //   Map<String, dynamic> toJson() =>
// //       {
// //         'id' : id,
// //         'email': email,
// //         'username': username,
// //         'firstName': firstName,
// //         'lastName': lastName,
// //         'displayName': displayName,
// //         'role': role,
// //         'fcmToken': fcmToken,
// //         'isClient': isClient,
// //         'isHCP' : isHCP,
// //         'isBranch': isBranch,
// //         'isCMS': isCMS
// //       };
// // @override
// // bool operator ==(Object o) {
// //   if (identical(this, o)) return true;
// //
// //   return o is User &&
// //       o.email == email;
// // }
// //
// // @override
// // int get hashCode => email.hashCode;
